extends ColorRect

const MAX_ALPHA: float = 0.3
const BASE_COLOR: Color = Color(0.8, 0.0, 0.0, 0.0)

var player_state: Node = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	player_state = get_node_or_null("/root/PlayerState")
	color = BASE_COLOR


func _process(_delta: float) -> void:
	if player_state == null:
		player_state = get_node_or_null("/root/PlayerState")
		if player_state == null:
			color = BASE_COLOR
			return

	var detection_value: Variant = player_state.get("detection_level")
	if typeof(detection_value) != TYPE_FLOAT:
		color = BASE_COLOR
		return

	var detection_level: float = clampf(detection_value as float, 0.0, 1.0)
	color = Color(BASE_COLOR.r, BASE_COLOR.g, BASE_COLOR.b, detection_level * MAX_ALPHA)
