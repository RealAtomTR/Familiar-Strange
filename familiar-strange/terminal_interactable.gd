extends StaticBody3D

signal terminal_completed()

@export var mesh_instance_path: NodePath
@export var panel_path: NodePath
@export var status_label_path: NodePath
@export var complete_button_path: NodePath
@export var close_button_path: NodePath
@export var terminal_id: StringName

static var active_terminal: Node = null

var mesh_instance: MeshInstance3D = null
var panel: Control = null
var status_label: Label = null
var complete_button: Button = null
var close_button: Button = null
var is_completed: bool = false


func _ready() -> void:
	mesh_instance = get_node_or_null(mesh_instance_path) as MeshInstance3D
	panel = get_node_or_null(panel_path) as Control
	status_label = get_node_or_null(status_label_path) as Label
	complete_button = get_node_or_null(complete_button_path) as Button
	close_button = get_node_or_null(close_button_path) as Button

	if terminal_id.is_empty():
		terminal_id = StringName(name)

	if complete_button != null and not complete_button.pressed.is_connected(_on_complete_button_pressed):
		complete_button.pressed.connect(_on_complete_button_pressed)

	if close_button != null and not close_button.pressed.is_connected(_on_close_button_pressed):
		close_button.pressed.connect(_on_close_button_pressed)

	_close_panel()
	_apply_visual_state()


func _on_interact() -> void:
	if is_completed:
		return

	if panel == null:
		push_warning("TerminalInteractable: panel reference is missing.")
		return

	_open_panel()


func _open_panel() -> void:
	if panel == null:
		return

	active_terminal = self
	panel.visible = true
	if status_label != null:
		if is_completed:
			status_label.text = "Terminal already completed."
		else:
			status_label.text = "Terminal placeholder active. Press Complete to finish."

	if complete_button != null:
		complete_button.disabled = is_completed


func _close_panel() -> void:
	if panel != null:
		panel.visible = false
	if active_terminal == self:
		active_terminal = null


func _on_complete_button_pressed() -> void:
	if active_terminal != self:
		return

	if is_completed:
		return

	var completion_registered: bool = _register_terminal_completion()
	if not completion_registered:
		return

	is_completed = true
	terminal_completed.emit()
	_apply_visual_state()
	_close_panel()


func _on_close_button_pressed() -> void:
	if active_terminal != self:
		return

	_close_panel()


func _register_terminal_completion() -> bool:
	var game_state: Node = get_node_or_null("/root/GameState")
	if game_state == null:
		push_warning("TerminalInteractable: GameState autoload is missing.")
		return false

	if not game_state.has_method("register_terminal_completion"):
		push_warning("TerminalInteractable: GameState completion API is missing.")
		return false

	return game_state.call("register_terminal_completion", terminal_id) as bool


func _apply_visual_state() -> void:
	if mesh_instance == null:
		push_warning("TerminalInteractable: mesh_instance reference is missing.")
		return

	var material: StandardMaterial3D = StandardMaterial3D.new()
	if is_completed:
		material.albedo_color = Color(0.2, 0.75, 0.95, 1.0)
	else:
		material.albedo_color = Color(0.15, 0.85, 0.85, 1.0)

	mesh_instance.material_override = material
