extends CharacterBody2D
class_name Enemy

enum EnemyType {
	BLUE
}

@export
var player: Player

@export
var type: EnemyType = EnemyType.BLUE

const enemy_ball_type_map: Dictionary[EnemyType, Ball.BallType] = {
	EnemyType.BLUE: Ball.BallType.BLUE
}

@export
var speed: float = 100
@export
var rotation_speed_deg: float = 10
@export
var enemy_prefered_distance: float = 25
@export
var enemy_slow_down_distance: float = 25

@export
var ball_scene: PackedScene
@export
var ball_spawn_distance: float = 20
@export
var coin_scene: PackedScene


@export
var additionals_spawn_location: Node2D

@export
var max_hp: int = 1
var hp := 1:
	set(val):
		hp = val
		if hp != 0: return
		die()

var rotation_speed: float:
	get():
		return deg_to_rad(rotation_speed_deg)

func _ready() -> void:
	hp = max_hp
	throw_ball.call_deferred()

func _physics_process(delta: float) -> void:
	var rotation_this_frame := rotation_speed*delta
	var displacement := (player.global_position-global_position)
	var displacement_normalized := displacement.normalized()
	var rotation_required := (displacement).angle()-rotation
	if not is_zero_approx(rotation_required):
		if rotation_required < 0:
			rotation_this_frame = -rotation_this_frame
		if abs(rotation_required) < abs(rotation_this_frame):
			rotation_this_frame = rotation_required
		rotation += rotation_this_frame
	var prefered_distance := player.paddle_distance + enemy_prefered_distance
	if prefered_distance > displacement.length():
		displacement_normalized = -displacement_normalized
	var prefered_position := player.global_position-displacement.normalized()*prefered_distance
	var prefered_displacement := prefered_position-global_position
	if is_equal_approx(prefered_distance, displacement.length()):
		velocity = Vector2.ZERO
	else:
		velocity = displacement_normalized*speed*min(1, prefered_displacement.length()/enemy_slow_down_distance)
	move_and_slide()

func throw_ball():
	var displacement := player.global_position-global_position
	var ball_direction := displacement.normalized()
	var ball_spawn_position := global_position+ball_direction*ball_spawn_distance
	var ball: Ball = ball_scene.instantiate()
	ball.direction = ball_direction
	ball.type = enemy_ball_type_map.get(type)
	additionals_spawn_location.add_child(ball)
	ball.global_position = ball_spawn_position


func die():
	var coin: Coin = coin_scene.instantiate()
	additionals_spawn_location.add_child(coin)
	coin.global_position = global_position
	queue_free()
