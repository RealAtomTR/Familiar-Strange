extends Node3D

const GAME_STATE_SCRIPT := preload("res://game_state.gd")

@export var camera_path: NodePath
@export var phase_1_camera_path: NodePath
@export var move_speed: float = 2.8
@export var mouse_sensitivity: float = 0.08
@export var movement_bounds_min: Vector3 = Vector3(-2.0, 1.6, -3.0)
@export var movement_bounds_max: Vector3 = Vector3(2.0, 1.6, 3.0)
@export_range(-85.0, 0.0, 1.0) var min_pitch_degrees: float = -45.0
@export_range(0.0, 85.0, 1.0) var max_pitch_degrees: float = 45.0

var camera: Camera3D = null
var phase_1_camera: Camera3D = null
var game_state: Node = null
var is_phase_2_active: bool = false
var is_mouse_capture_requested: bool = false
var pitch_degrees: float = 0.0


func _ready() -> void:
	camera = get_node_or_null(camera_path) as Camera3D
	phase_1_camera = get_node_or_null(phase_1_camera_path) as Camera3D
	game_state = get_node_or_null("/root/GameState")

	if game_state != null:
		if game_state.has_signal("state_changed") and not game_state.state_changed.is_connected(_on_game_state_changed):
			game_state.state_changed.connect(_on_game_state_changed)
	else:
		push_warning("Phase2PlayerController: GameState autoload is missing.")

	_refresh_phase_state()


func _exit_tree() -> void:
	_release_mouse()


func _physics_process(delta: float) -> void:
	if not is_phase_2_active:
		return

	var movement_input: Vector3 = _get_movement_input()
	if movement_input.is_zero_approx():
		return

	var forward: Vector3 = -global_transform.basis.z
	forward.y = 0.0
	forward = forward.normalized()

	var right: Vector3 = global_transform.basis.x
	right.y = 0.0
	right = right.normalized()

	var movement: Vector3 = ((right * movement_input.x) + (forward * movement_input.z)).normalized()
	global_position += movement * move_speed * delta
	_clamp_to_bounds()


func _unhandled_input(event: InputEvent) -> void:
	if not is_phase_2_active:
		return

	if event is InputEventKey:
		var key_event: InputEventKey = event as InputEventKey
		if key_event.pressed and not key_event.echo and key_event.keycode == KEY_ESCAPE:
			_release_mouse()
			get_viewport().set_input_as_handled()
			return

	if event is InputEventMouseButton:
		var mouse_button_event: InputEventMouseButton = event as InputEventMouseButton
		if mouse_button_event.pressed and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			_capture_mouse()
			get_viewport().set_input_as_handled()
			return

	if event is InputEventMouseMotion and is_mouse_capture_requested:
		var mouse_motion: InputEventMouseMotion = event as InputEventMouseMotion
		rotation_degrees.y -= mouse_motion.relative.x * mouse_sensitivity
		pitch_degrees = clampf(
			pitch_degrees - (mouse_motion.relative.y * mouse_sensitivity),
			min_pitch_degrees,
			max_pitch_degrees
		)
		_apply_camera_pitch()


func is_active() -> bool:
	return is_phase_2_active


func is_mouse_captured() -> bool:
	return is_mouse_capture_requested


func _get_movement_input() -> Vector3:
	var movement_input: Vector3 = Vector3.ZERO
	if Input.is_key_pressed(KEY_A):
		movement_input.x -= 1.0
	if Input.is_key_pressed(KEY_D):
		movement_input.x += 1.0
	if Input.is_key_pressed(KEY_W):
		movement_input.z += 1.0
	if Input.is_key_pressed(KEY_S):
		movement_input.z -= 1.0
	return movement_input


func _on_game_state_changed(_previous_state: int, _new_state: int) -> void:
	_refresh_phase_state()


func _refresh_phase_state() -> void:
	var should_be_active: bool = false
	if game_state != null:
		should_be_active = int(game_state.get("current_state")) == GAME_STATE_SCRIPT.GAME_STATE.PHASE_2_3D

	if is_phase_2_active == should_be_active:
		_apply_camera_state()
		return

	is_phase_2_active = should_be_active
	_apply_camera_state()


func _apply_camera_state() -> void:
	if camera == null:
		return

	camera.current = is_phase_2_active
	if phase_1_camera != null:
		phase_1_camera.current = not is_phase_2_active

	if is_phase_2_active:
		_capture_mouse()
		_apply_camera_pitch()
	else:
		_release_mouse()


func _apply_camera_pitch() -> void:
	if camera == null:
		return

	camera.rotation_degrees.x = pitch_degrees


func _capture_mouse() -> void:
	is_mouse_capture_requested = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _release_mouse() -> void:
	is_mouse_capture_requested = false
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _clamp_to_bounds() -> void:
	global_position = Vector3(
		clampf(global_position.x, movement_bounds_min.x, movement_bounds_max.x),
		clampf(global_position.y, movement_bounds_min.y, movement_bounds_max.y),
		clampf(global_position.z, movement_bounds_min.z, movement_bounds_max.z)
	)