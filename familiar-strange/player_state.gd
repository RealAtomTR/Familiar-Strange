extends Node

signal noise_generated(noise_amount: float, detection_level: float)
signal player_caught()

const GAME_STATE_SCRIPT := preload("res://game_state.gd")

var detection_level: float = 0.0
var noise_level: float = 0.0
var is_caught: bool = false


func add_detection(amount: float) -> void:
	detection_level = clampf(detection_level + maxf(amount, 0.0), 0.0, 1.0)
	if not is_caught and is_equal_approx(detection_level, 1.0):
		is_caught = true
		_change_game_state(GAME_STATE_SCRIPT.GAME_STATE.CAUGHT)
		_on_caught()


func reduce_detection(amount: float) -> void:
	detection_level = clampf(detection_level - maxf(amount, 0.0), 0.0, 1.0)
	if is_caught and detection_level < 1.0 and not is_equal_approx(detection_level, 1.0):
		is_caught = false


func register_noise(amount: float) -> void:
	noise_level = maxf(amount, 0.0)
	add_detection(noise_level)
	noise_generated.emit(noise_level, detection_level)


func reset_state() -> void:
	detection_level = 0.0
	noise_level = 0.0
	is_caught = false
	_reset_phase_1_progress()
	_reset_phase_2_exit_placeholder_completion()
	_change_game_state(GAME_STATE_SCRIPT.GAME_STATE.PHASE_1_2D)
	noise_generated.emit(noise_level, detection_level)


func _on_caught() -> void:
	player_caught.emit()


func _change_game_state(new_state: int) -> void:
	var game_state: Node = get_node_or_null("/root/GameState")
	if game_state == null:
		push_warning("PlayerState: GameState autoload is missing.")
		return

	if game_state.has_method("change_state"):
		game_state.call("change_state", new_state)


func _reset_phase_1_progress() -> void:
	var game_state: Node = get_node_or_null("/root/GameState")
	if game_state == null:
		push_warning("PlayerState: GameState autoload is missing.")
		return

	if game_state.has_method("reset_phase_1_progress"):
		game_state.call("reset_phase_1_progress")


func _reset_phase_2_exit_placeholder_completion() -> void:
	var game_state: Node = get_node_or_null("/root/GameState")
	if game_state == null:
		push_warning("PlayerState: GameState autoload is missing.")
		return

	if game_state.has_method("reset_phase_2_exit_placeholder_completion"):
		game_state.call("reset_phase_2_exit_placeholder_completion")
