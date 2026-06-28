extends Node3D

const CLICK_THRESHOLD: float = 8.0

@export var camera_path: NodePath
@export var previous_button_path: NodePath
@export var next_button_path: NodePath
@export var waypoint_paths: Array[NodePath] = []
@export var terminal_panel_path: NodePath
@export var interact_max_distance: float = 20.0
@export_range(0.05, 2.0, 0.05) var transition_duration: float = 0.35
@export_enum("Linear:0", "Sine:1", "Quint:2", "Quart:3", "Quad:4", "Expo:5", "Elastic:6", "Cubic:7", "Circ:8", "Bounce:9", "Back:10", "Spring:11") var transition_type: int = Tween.TRANS_SINE
@export_enum("In:0", "Out:1", "In Out:2", "Out In:3") var ease_type: int = Tween.EASE_IN_OUT
@export var limited_look_enabled: bool = true
@export_range(0.0, 25.0, 0.5) var limited_look_yaw_degrees: float = 10.0
@export_range(0.0, 15.0, 0.5) var limited_look_pitch_degrees: float = 4.0
@export_range(0.01, 1.0, 0.01) var limited_look_sensitivity: float = 0.08

var camera: Camera3D = null
var previous_button: Button = null
var next_button: Button = null
var terminal_panel: Control = null
var waypoints: Array[Marker3D] = []
var current_waypoint_index: int = 0
var mouse_press_position: Vector2 = Vector2.ZERO
var is_left_mouse_button_down: bool = false
var is_right_mouse_button_down: bool = false
var is_transitioning: bool = false
var active_tween: Tween = null
var current_look_yaw_degrees: float = 0.0
var current_look_pitch_degrees: float = 0.0


func _ready() -> void:
	camera = get_node_or_null(camera_path) as Camera3D
	previous_button = get_node_or_null(previous_button_path) as Button
	next_button = get_node_or_null(next_button_path) as Button
	terminal_panel = get_node_or_null(terminal_panel_path) as Control
	waypoints = _resolve_waypoints()

	if camera == null:
		push_warning("Phase1WaypointController: camera reference is missing.")
		return

	if previous_button != null and not previous_button.pressed.is_connected(_on_previous_button_pressed):
		previous_button.pressed.connect(_on_previous_button_pressed)

	if next_button != null and not next_button.pressed.is_connected(_on_next_button_pressed):
		next_button.pressed.connect(_on_next_button_pressed)

	if waypoints.is_empty():
		push_warning("Phase1WaypointController: waypoint list is empty.")
		_update_button_states()
		return

	current_waypoint_index = clampi(current_waypoint_index, 0, waypoints.size() - 1)
	_place_camera_at_current_waypoint()
	_update_button_states()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_handle_mouse_motion(event as InputEventMouseMotion)
		return

	if event is not InputEventMouseButton:
		return

	var mouse_button_event: InputEventMouseButton = event as InputEventMouseButton
	if mouse_button_event.button_index == MOUSE_BUTTON_RIGHT:
		_handle_right_mouse_button(mouse_button_event)
		return

	if is_transitioning or mouse_button_event.button_index != MOUSE_BUTTON_LEFT:
		return

	if mouse_button_event.pressed:
		is_left_mouse_button_down = true
		mouse_press_position = mouse_button_event.position
		return

	if not is_left_mouse_button_down:
		return

	is_left_mouse_button_down = false
	var drag_distance: float = mouse_button_event.position.distance_to(mouse_press_position)
	if drag_distance < CLICK_THRESHOLD:
		_try_interact(mouse_button_event.position)


func _on_previous_button_pressed() -> void:
	if is_transitioning or current_waypoint_index <= 0:
		return

	current_waypoint_index -= 1
	_animate_camera_to_current_waypoint()


func _on_next_button_pressed() -> void:
	if is_transitioning or current_waypoint_index >= waypoints.size() - 1:
		return

	current_waypoint_index += 1
	_animate_camera_to_current_waypoint()


func _place_camera_at_current_waypoint() -> void:
	var current_waypoint: Marker3D = waypoints[current_waypoint_index]
	camera.global_position = current_waypoint.global_position
	_apply_current_waypoint_rotation()


func _animate_camera_to_current_waypoint() -> void:
	if camera == null:
		return

	var current_waypoint: Marker3D = waypoints[current_waypoint_index]
	if is_instance_valid(active_tween):
		active_tween.kill()

	_reset_limited_look_offset()
	is_transitioning = true
	is_left_mouse_button_down = false
	is_right_mouse_button_down = false
	_update_button_states()

	active_tween = create_tween()
	active_tween.set_trans(transition_type)
	active_tween.set_ease(ease_type)
	active_tween.parallel().tween_property(camera, "global_position", current_waypoint.global_position, transition_duration)
	active_tween.parallel().tween_property(camera, "global_rotation", current_waypoint.global_rotation, transition_duration)
	active_tween.finished.connect(_on_camera_transition_finished, CONNECT_ONE_SHOT)


func _on_camera_transition_finished() -> void:
	active_tween = null
	is_transitioning = false
	_place_camera_at_current_waypoint()
	_update_button_states()


func _try_interact(screen_position: Vector2) -> void:
	if camera == null or is_transitioning:
		return

	var ray_origin: Vector3 = camera.project_ray_origin(screen_position)
	var ray_direction: Vector3 = camera.project_ray_normal(screen_position)
	var ray_target: Vector3 = ray_origin + (ray_direction * interact_max_distance)
	var ray_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(ray_origin, ray_target)
	ray_query.exclude = [camera]

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var result: Dictionary = space_state.intersect_ray(ray_query)
	if result.is_empty():
		return

	var collider: Object = result.get("collider") as Object
	var interactable_body: StaticBody3D = _resolve_interactable_body(collider)
	if interactable_body == null:
		return

	if interactable_body.has_method("_on_interact"):
		interactable_body.call("_on_interact")


func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	if not _can_use_limited_look() or not is_right_mouse_button_down:
		return

	current_look_yaw_degrees = clampf(
		current_look_yaw_degrees - (event.relative.x * limited_look_sensitivity),
		-limited_look_yaw_degrees,
		limited_look_yaw_degrees
	)
	current_look_pitch_degrees = clampf(
		current_look_pitch_degrees - (event.relative.y * limited_look_sensitivity),
		-limited_look_pitch_degrees,
		limited_look_pitch_degrees
	)
	_apply_current_waypoint_rotation()


func _handle_right_mouse_button(event: InputEventMouseButton) -> void:
	if event.pressed:
		is_right_mouse_button_down = _can_use_limited_look()
		return

	is_right_mouse_button_down = false


func _apply_current_waypoint_rotation() -> void:
	if camera == null or waypoints.is_empty():
		return

	var current_waypoint: Marker3D = waypoints[current_waypoint_index]
	var target_rotation_degrees: Vector3 = current_waypoint.global_rotation_degrees
	target_rotation_degrees.x += current_look_pitch_degrees
	target_rotation_degrees.y += current_look_yaw_degrees
	camera.global_rotation_degrees = target_rotation_degrees


func _reset_limited_look_offset() -> void:
	current_look_yaw_degrees = 0.0
	current_look_pitch_degrees = 0.0


func _can_use_limited_look() -> bool:
	return limited_look_enabled and not is_transitioning and not _is_terminal_panel_open()


func _is_terminal_panel_open() -> bool:
	return terminal_panel != null and terminal_panel.visible


func _resolve_interactable_body(collider: Object) -> StaticBody3D:
	if collider == null:
		return null

	var collider_node: Node = collider as Node
	if collider_node == null:
		return null

	var interactable_body: StaticBody3D = collider_node as StaticBody3D
	if interactable_body == null:
		interactable_body = collider_node.get_parent() as StaticBody3D

	if interactable_body == null:
		return null

	if not interactable_body.name.to_lower().contains("interactable"):
		return null

	return interactable_body


func _resolve_waypoints() -> Array[Marker3D]:
	var resolved_waypoints: Array[Marker3D] = []
	for waypoint_path: NodePath in waypoint_paths:
		var waypoint: Marker3D = get_node_or_null(waypoint_path) as Marker3D
		if waypoint != null:
			resolved_waypoints.append(waypoint)
	return resolved_waypoints


func _update_button_states() -> void:
	if previous_button != null:
		previous_button.disabled = is_transitioning or current_waypoint_index <= 0

	if next_button != null:
		next_button.disabled = is_transitioning or waypoints.is_empty() or current_waypoint_index >= waypoints.size() - 1