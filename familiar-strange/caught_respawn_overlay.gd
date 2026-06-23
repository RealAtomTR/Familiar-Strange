extends ColorRect

const FADE_DURATION: float = 0.2
const RESPAWN_DELAY: float = 0.8
const HIDDEN_COLOR: Color = Color(0.0, 0.0, 0.0, 0.0)
const VISIBLE_COLOR: Color = Color(0.0, 0.0, 0.0, 1.0)

var is_respawning: bool = false
var player_state: Node = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = false
	color = HIDDEN_COLOR
	player_state = get_node_or_null("/root/PlayerState")
	if player_state != null and not player_state.player_caught.is_connected(_on_player_caught):
		player_state.player_caught.connect(_on_player_caught)


func _on_player_caught() -> void:
	if is_respawning:
		return

	is_respawning = true
	visible = true
	var fade_tween: Tween = create_tween()
	fade_tween.tween_property(self, "color", VISIBLE_COLOR, FADE_DURATION)
	await fade_tween.finished
	await get_tree().create_timer(RESPAWN_DELAY).timeout

	if player_state != null and player_state.has_method("reset_state"):
		player_state.call("reset_state")

	is_respawning = false
	get_tree().reload_current_scene()
