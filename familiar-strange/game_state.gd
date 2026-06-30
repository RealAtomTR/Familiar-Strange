extends Node

signal state_changed(previous_state: int, new_state: int)
signal phase_1_progress_changed(completed_count: int, target_count: int)
signal phase_2_exit_placeholder_completed()

enum GAME_STATE {
	PHASE_1_2D,
	PHASE_TRANSITION,
	PHASE_2_3D,
	CAUGHT,
	GAME_OVER
}

const PHASE_1_COMPLETION_TARGET: int = 3

var current_state: GAME_STATE = GAME_STATE.PHASE_1_2D
var completed_terminal_count: int = 0
var phase_1_completion_target: int = PHASE_1_COMPLETION_TARGET
var completed_terminal_ids: Array[StringName] = []
var is_phase_2_exit_placeholder_completed: bool = false


func change_state(new_state: GAME_STATE) -> void:
	if current_state == new_state:
		return

	var previous_state: GAME_STATE = current_state
	current_state = new_state
	state_changed.emit(previous_state, current_state)

func register_terminal_completion(terminal_id: StringName) -> bool:
	if terminal_id.is_empty():
		push_warning("GameState: terminal_id is empty.")
		return false

	if completed_terminal_ids.has(terminal_id):
		return false

	completed_terminal_ids.append(terminal_id)
	completed_terminal_count = completed_terminal_ids.size()
	phase_1_progress_changed.emit(completed_terminal_count, phase_1_completion_target)

	if completed_terminal_count >= phase_1_completion_target:
		_on_phase_1_completion_target_reached()

	return true


func reset_phase_1_progress() -> void:
	completed_terminal_ids.clear()
	completed_terminal_count = 0
	phase_1_progress_changed.emit(completed_terminal_count, phase_1_completion_target)


func register_phase_2_exit_placeholder_completion() -> bool:
	if current_state != GAME_STATE.PHASE_2_3D:
		return false

	if is_phase_2_exit_placeholder_completed:
		return false

	is_phase_2_exit_placeholder_completed = true
	phase_2_exit_placeholder_completed.emit()
	return true


func reset_phase_2_exit_placeholder_completion() -> void:
	is_phase_2_exit_placeholder_completed = false


func _on_phase_1_completion_target_reached() -> void:
	if current_state != GAME_STATE.PHASE_1_2D:
		return

	change_state(GAME_STATE.PHASE_TRANSITION)
