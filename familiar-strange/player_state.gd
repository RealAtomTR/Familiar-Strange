extends Node

signal noise_generated(noise_amount: float, detection_level: float)
signal player_caught()

var detection_level: float = 0.0
var noise_level: float = 0.0
var is_caught: bool = false


func add_detection(amount: float) -> void:
	detection_level = clampf(detection_level + maxf(amount, 0.0), 0.0, 1.0)
	if not is_caught and is_equal_approx(detection_level, 1.0):
		is_caught = true
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
	noise_generated.emit(noise_level, detection_level)


func _on_caught() -> void:
	player_caught.emit()
