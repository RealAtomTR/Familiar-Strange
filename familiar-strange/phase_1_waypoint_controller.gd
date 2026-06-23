extends Node3D

const CLICK_THRESHOLD: float = 8.0

@export var camera_path: NodePath
@export var previous_button_path: NodePath
@export var next_button_path: NodePath
@export var waypoint_paths: Array[NodePath] = []
@export var interact_max_distance: float = 20.0

var camera: Camera3D = null
var previous_button: Button = null
var next_button: Button = null
var waypoints: Array[Marker3D] = []
var current_waypoint_index: int = 0
var mouse_press_position: Vector2 = Vector2.ZERO
var is_left_mouse_button_down: bool = false


func _ready() -> void:
	camera = get_node_or_null(camera_path) as Camera3D
	previous_button = get_node_or_null(previous_button_path) as Button
	next_button = get_node_or_null(next_button_path) as Button
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
	_move_camera_to_current_waypoint()
	_update_button_states()


func _unhandled_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return

	var mouse_button_event: InputEventMouseButton = event as InputEventMouseButton
	if mouse_button_event.button_index != MOUSE_BUTTON_LEFT:
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
		_try_interact()


func _on_previous_button_pressed() -> void:
	if current_waypoint_index <= 0:
		return

	current_waypoint_index -= 1
	_move_camera_to_current_waypoint()
	_update_button_states()


func _on_next_button_pressed() -> void:
	if current_waypoint_index >= waypoints.size() - 1:
		return

	current_waypoint_index += 1
	_move_camera_to_current_waypoint()
	_update_button_states()


func _move_camera_to_current_waypoint() -> void:
	var current_waypoint: Marker3D = waypoints[current_waypoint_index]
	camera.global_position = current_waypoint.global_position


func _try_interact() -> void:
	if camera == null:
		return

	var ray_origin: Vector3 = camera.global_position
	var ray_target: Vector3 = ray_origin + (-camera.global_basis.z * interact_max_distance)
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
		previous_button.disabled = current_waypoint_index <= 0

	if next_button != null:
		next_button.disabled = waypoints.is_empty() or current_waypoint_index >= waypoints.size() - 1
