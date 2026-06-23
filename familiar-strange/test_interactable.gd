extends StaticBody3D

enum SearchState {
	IDLE,
	AWAITING_CHOICE,
	SEARCHED
}

const SLOW_SEARCH_NOISE: float = 0.1
const FAST_SEARCH_NOISE: float = 0.35

@export var mesh_instance_path: NodePath

var mesh_instance: MeshInstance3D = null
var search_state: SearchState = SearchState.IDLE
var last_noise_amount: float = 0.0


func _ready() -> void:
	mesh_instance = get_node_or_null(mesh_instance_path) as MeshInstance3D
	_apply_visual_state()


func _on_interact() -> void:
	if search_state != SearchState.IDLE:
		return

	search_state = SearchState.AWAITING_CHOICE
	_apply_visual_state()
	print("Search choice active: press Q for slow search or E for fast search.")


func _unhandled_input(event: InputEvent) -> void:
	if search_state != SearchState.AWAITING_CHOICE:
		return

	if event is not InputEventKey:
		return

	var key_event: InputEventKey = event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return

	if key_event.keycode == KEY_Q:
		_complete_search(SLOW_SEARCH_NOISE)
	elif key_event.keycode == KEY_E:
		_complete_search(FAST_SEARCH_NOISE)


func _complete_search(noise_amount: float) -> void:
	search_state = SearchState.SEARCHED
	last_noise_amount = noise_amount
	_register_noise(noise_amount)
	_apply_visual_state()


func _register_noise(noise_amount: float) -> void:
	var player_state: Node = get_node_or_null("/root/PlayerState")
	if player_state == null:
		push_warning("SearchableInteractable: PlayerState autoload is missing.")
		return

	if player_state.has_method("register_noise"):
		player_state.call("register_noise", noise_amount)


func _apply_visual_state() -> void:
	if mesh_instance == null:
		push_warning("SearchableInteractable: mesh_instance reference is missing.")
		return

	var material: StandardMaterial3D = StandardMaterial3D.new()
	if search_state == SearchState.IDLE:
		material.albedo_color = Color(0.85, 0.25, 0.25, 1.0)
	elif search_state == SearchState.AWAITING_CHOICE:
		material.albedo_color = Color(0.95, 0.85, 0.2, 1.0)
	elif last_noise_amount <= SLOW_SEARCH_NOISE:
		material.albedo_color = Color(0.2, 0.85, 0.35, 1.0)
	else:
		material.albedo_color = Color(0.95, 0.45, 0.15, 1.0)

	mesh_instance.material_override = material
