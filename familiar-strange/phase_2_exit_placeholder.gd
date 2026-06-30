extends Area3D

const GAME_STATE_SCRIPT := preload("res://game_state.gd")

@export var player_path: NodePath
@export var completion_label_path: NodePath
@export var activation_radius: float = 0.85

var player_node: Node3D = null
var completion_label: Label = null
var game_state: Node = null
var is_phase_2_active: bool = false
var is_completed: bool = false


func _ready() -> void:
	player_node = get_node_or_null(player_path) as Node3D
	completion_label = get_node_or_null(completion_label_path) as Label
	game_state = get_node_or_null("/root/GameState")

	if game_state != null:
		if game_state.has_signal("state_changed") and not game_state.state_changed.is_connected(_on_game_state_changed):
			game_state.state_changed.connect(_on_game_state_changed)
		if game_state.has_signal("phase_2_exit_placeholder_completed") and not game_state.phase_2_exit_placeholder_completed.is_connected(_on_phase_2_completed):
			game_state.phase_2_exit_placeholder_completed.connect(_on_phase_2_completed)
	else:
		push_warning("Phase2ExitPlaceholder: GameState autoload is missing.")

	_refresh_phase_state()


func _physics_process(_delta: float) -> void:
	if not is_phase_2_active or is_completed:
		return

	if player_node == null:
		return

	if global_position.distance_to(player_node.global_position) <= activation_radius:
		_complete_placeholder()


func _on_game_state_changed(_previous_state: int, _new_state: int) -> void:
	_refresh_phase_state()


func _on_phase_2_completed() -> void:
	is_completed = true
	_refresh_phase_state()


func _complete_placeholder() -> void:
	if game_state == null:
		push_warning("Phase2ExitPlaceholder: GameState autoload is missing.")
		return

	if not game_state.has_method("register_phase_2_exit_placeholder_completion"):
		push_warning("Phase2ExitPlaceholder: completion API is missing.")
		return

	var completion_registered: bool = game_state.call("register_phase_2_exit_placeholder_completion") as bool
	if completion_registered:
		is_completed = true
		_refresh_phase_state()


func _refresh_phase_state() -> void:
	is_phase_2_active = false
	if game_state != null:
		is_phase_2_active = int(game_state.get("current_state")) == GAME_STATE_SCRIPT.GAME_STATE.PHASE_2_3D
		is_completed = game_state.get("is_phase_2_exit_placeholder_completed") as bool

	visible = is_phase_2_active
	monitoring = is_phase_2_active and not is_completed

	if completion_label != null:
		completion_label.visible = is_phase_2_active and is_completed
