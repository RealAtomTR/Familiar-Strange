extends ColorRect

const GLITCH_FLASH_DURATION: float = 0.08
const GLITCH_DARKEN_DURATION: float = 0.22
const GLITCH_SETTLE_DURATION: float = 0.2
const HIDDEN_COLOR: Color = Color(0.0, 0.0, 0.0, 0.0)
const FLASH_COLOR: Color = Color(0.85, 0.9, 1.0, 0.65)
const DARK_COLOR: Color = Color(0.0, 0.0, 0.0, 0.95)

const GAME_STATE_PHASE_TRANSITION: int = 1
const GAME_STATE_PHASE_2_3D: int = 2

var game_state: Node = null
var is_transition_running: bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = false
	color = HIDDEN_COLOR
	game_state = get_node_or_null("/root/GameState")
	if game_state != null and not game_state.state_changed.is_connected(_on_state_changed):
		game_state.state_changed.connect(_on_state_changed)


func _on_state_changed(_previous_state: int, new_state: int) -> void:
	if new_state != GAME_STATE_PHASE_TRANSITION:
		return

	if is_transition_running:
		return

	_run_transition()


func _run_transition() -> void:
	is_transition_running = true
	visible = true
	color = HIDDEN_COLOR

	var transition_tween: Tween = create_tween()
	transition_tween.tween_property(self, "color", FLASH_COLOR, GLITCH_FLASH_DURATION)
	transition_tween.tween_property(self, "color", DARK_COLOR, GLITCH_DARKEN_DURATION)
	transition_tween.tween_property(self, "color", HIDDEN_COLOR, GLITCH_SETTLE_DURATION)
	await transition_tween.finished

	if game_state != null and game_state.has_method("change_state"):
		game_state.call("change_state", GAME_STATE_PHASE_2_3D)

	visible = false
	is_transition_running = false
