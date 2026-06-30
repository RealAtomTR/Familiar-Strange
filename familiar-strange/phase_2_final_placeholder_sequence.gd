extends Node

const GAME_STATE_SCRIPT := preload("res://game_state.gd")

@export var phase_2_player_path: NodePath
@export var camera_path: NodePath
@export var door_panel_path: NodePath
@export var final_screen_path: NodePath
@export var door_open_offset: Vector3 = Vector3(0.95, 0.0, 0.0)
@export var staging_position: Vector3 = Vector3(12.4, 1.6, -6.75)
@export var staging_rotation_degrees: Vector3 = Vector3(0.0, 0.0, 0.0)
@export var camera_target_position: Vector3 = Vector3(12.4, 1.6, -8.65)
@export var camera_target_rotation_degrees: Vector3 = Vector3(0.0, 0.0, 0.0)
@export var staging_duration: float = 0.55
@export var door_open_duration: float = 0.65
@export var camera_move_duration: float = 1.15
@export_range(45.0, 100.0, 1.0) var final_camera_fov: float = 78.0

var game_state: Node = null
var phase_2_player: Node3D = null
var phase_2_camera: Camera3D = null
var door_panel: Node3D = null
var final_screen: Node3D = null
var has_played: bool = false
var is_running: bool = false


func _ready() -> void:
	game_state = get_node_or_null("/root/GameState")
	phase_2_player = get_node_or_null(phase_2_player_path) as Node3D
	phase_2_camera = get_node_or_null(camera_path) as Camera3D
	door_panel = get_node_or_null(door_panel_path) as Node3D
	final_screen = get_node_or_null(final_screen_path) as Node3D

	if final_screen != null:
		final_screen.visible = false

	if game_state == null:
		push_warning("Phase2FinalPlaceholderSequence: GameState autoload is missing.")
		return

	if game_state.has_signal("phase_2_exit_placeholder_completed") and not game_state.phase_2_exit_placeholder_completed.is_connected(_on_phase_2_exit_placeholder_completed):
		game_state.phase_2_exit_placeholder_completed.connect(_on_phase_2_exit_placeholder_completed)

	var is_already_completed: bool = game_state.get("is_phase_2_exit_placeholder_completed") as bool
	if is_already_completed:
		call_deferred("_on_phase_2_exit_placeholder_completed")


func _on_phase_2_exit_placeholder_completed() -> void:
	if has_played or is_running:
		return

	if game_state == null:
		return

	if int(game_state.get("current_state")) != GAME_STATE_SCRIPT.GAME_STATE.PHASE_2_3D:
		return

	_run_sequence()


func _run_sequence() -> void:
	has_played = true
	is_running = true
	_set_player_controls_locked(true)

	if final_screen != null:
		final_screen.visible = false

	_apply_final_camera_fov()
	await _move_camera_to_staging()
	await _open_door()
	await _move_camera_through_door()

	if final_screen != null:
		final_screen.visible = true

	is_running = false


func _move_camera_to_staging() -> void:
	if phase_2_player == null:
		return

	var staging_tween: Tween = create_tween()
	staging_tween.set_parallel(true)
	staging_tween.set_trans(Tween.TRANS_CUBIC)
	staging_tween.set_ease(Tween.EASE_IN_OUT)
	staging_tween.tween_property(phase_2_player, "global_position", staging_position, staging_duration)
	staging_tween.tween_property(phase_2_player, "rotation_degrees", staging_rotation_degrees, staging_duration)
	if phase_2_camera != null:
		staging_tween.tween_property(phase_2_camera, "rotation_degrees", Vector3.ZERO, staging_duration)
	await staging_tween.finished


func _open_door() -> void:
	if door_panel == null:
		return

	var target_position: Vector3 = door_panel.global_position + door_open_offset
	var door_tween: Tween = create_tween()
	door_tween.set_trans(Tween.TRANS_CUBIC)
	door_tween.set_ease(Tween.EASE_IN_OUT)
	door_tween.tween_property(door_panel, "global_position", target_position, door_open_duration)
	await door_tween.finished


func _move_camera_through_door() -> void:
	if phase_2_player == null:
		return

	var camera_tween: Tween = create_tween()
	camera_tween.set_parallel(true)
	camera_tween.set_trans(Tween.TRANS_CUBIC)
	camera_tween.set_ease(Tween.EASE_IN_OUT)
	camera_tween.tween_property(phase_2_player, "global_position", camera_target_position, camera_move_duration)
	camera_tween.tween_property(phase_2_player, "rotation_degrees", camera_target_rotation_degrees, camera_move_duration)
	if phase_2_camera != null:
		camera_tween.tween_property(phase_2_camera, "rotation_degrees", Vector3.ZERO, camera_move_duration)
	await camera_tween.finished


func _apply_final_camera_fov() -> void:
	if phase_2_camera == null:
		return

	phase_2_camera.fov = final_camera_fov


func _set_player_controls_locked(locked: bool) -> void:
	if phase_2_player == null:
		return

	if phase_2_player.has_method("set_sequence_locked"):
		phase_2_player.call("set_sequence_locked", locked)
