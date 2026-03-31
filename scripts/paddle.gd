extends StaticBody2D
class_name Paddle

var PADDLE_OFFSET = 50
var direction = Vector2.ZERO
var rotation_offset = 0
var position_offset: Vector2
var dir_rad = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dir_rad = deg_to_rad(direction)
	position_offset = PADDLE_OFFSET * Vector2(cos(dir_rad), sin(dir_rad))
	global_position = get_parent().global_position + position_offset
	rotation_degrees = direction
