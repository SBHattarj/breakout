extends CharacterBody2D

var direction: Vector2
const acceleration = 2000
var speed_x: float = 0
var speed_y: float = 0
var player_lastdir = Vector2(0,-1)
var paddle_scene = preload("res://scenes/paddle.tscn")
var paddles = []
var paddle_count = 0
var direction_deg = 0
# initializes speed and direction

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const diagonal_speed = 0.707
const friction = 0.8

func _physics_process(delta: float) -> void:
	velocity = Vector2(speed_x, speed_y)
	animation()
	move_and_slide()
	set_paddle_positions()
	# moves the player in the speed and direction stated
	
	direction = Input.get_vector("left", "right", "up", "down")
	if not direction == Vector2.ZERO:
		player_lastdir = direction
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction *= diagonal_speed
	# slows down the player if they're moving diagonally
	speed_x += direction.x * acceleration * delta
	speed_x *= friction
	
	speed_y += direction.y * acceleration * delta
	speed_y *= friction

func animation():
	if direction:
		if direction.x > 0:
			sprite.animation = "run_right"
		elif direction.x < 0:
			sprite.animation = "run_left"
		else:
			sprite.animation = "run_up" if direction.y < 0 else "run_down"
	else:
		if player_lastdir.x > 0:
			sprite.animation = "idle_right"
		elif player_lastdir.x:
			sprite.animation = "idle_left"
		else:
			sprite.animation = "idle_down" if player_lastdir.y < 0 else "idle_up"

func set_paddle_count(count):
	var paddle_count = count
	for i in paddles:
		i.queue_free()
	paddles.clear()
	
	for i in range(count):
		var paddle = paddle_scene.instantiate()
		var angle_offset = 360/count
		paddle.rotation_offset = angle_offset * (i-1)
		paddle.PADDLE_OFFSET = 28 + (count * 4)
		add_child(paddle)
		paddles.append(paddle)

func set_paddle_positions():
		var direction_vect = get_local_mouse_position().normalized()
		var direction_rad = atan2(direction_vect.y, direction_vect.x)
		var direction_deg_mouse = direction_rad * 180 / PI
		var diff = fmod(direction_deg_mouse - direction_deg + 540, 360) - 180
		direction_deg += diff/4
		for i in paddles:
			i.direction = int(direction_deg + i.rotation_offset) % 360

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		paddle_count += 1
		set_paddle_count(paddle_count)
