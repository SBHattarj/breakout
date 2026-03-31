@tool
extends CharacterBody2D

class_name Ball

enum BallCollideType {
	ENEMY,
	PLAYER
}

enum BallType {
	WHITE,
	BLUE
}

const BALL_TYPE_MAP: Dictionary[BallType, String] = {
	BallType.WHITE: "white",
	BallType.BLUE: "blue"
}

@export_flags_2d_physics
var enemy_collison_layer := 0

@export_flags_2d_physics
var player_collison_layer := 0

@export_flags_2d_physics
var paddle_collison_layer := 0

@export
var visible_on_screen_notifiers: Array[VisibleOnScreenNotifier2D] = []

@export
var direction := Vector2.UP:
	set(val):
		direction = val.normalized()

@export
var collison_type: BallCollideType = BallCollideType.ENEMY:
	set(val):
		collison_type = val
		match(collison_type):
			BallCollideType.ENEMY:
				#collision_layer = paddle_collison_layer | player_collison_layer
				collision_mask = paddle_collison_layer | player_collison_layer
			BallCollideType.PLAYER:
				#collision_layer = paddle_collison_layer | enemy_collison_layer
				collision_mask = paddle_collison_layer | enemy_collison_layer

@export
var type: BallType = BallType.WHITE:
	set(val):
		type = val
		play_animation()
@export
var sprite: AnimatedSprite2D

func play_animation():
	if sprite == null: return
	sprite.play(BALL_TYPE_MAP.get(type))

@export
var speed: float = 100
@export
var max_hp: int = 1

var hp: int = 1

func _ready() -> void:
	hp = max_hp
	play_animation()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	velocity = direction * speed
	
	if move_and_slide():
		for i in range(get_slide_collision_count()):
			var collison := get_slide_collision(i)
			var collison_body := collison.get_collider()
			var collison_normal := collison.get_normal()
			if _handle_player(collison_body):
				return
			if _handle_enemy(collison_body):
				return
			if collison_body is Paddle:
				if collison_type == BallCollideType.ENEMY:
					collison_type = BallCollideType.PLAYER
				if type != BallType.WHITE:
					type = BallType.WHITE
			if is_zero_approx(collison_normal.angle_to(-direction)):
				direction = -direction
				return
			var direction_reflection := direction-2*(direction).dot(collison_normal)*collison_normal
			direction = direction_reflection
			return

func _handle_player(body: Node) -> bool:
	if body is not Player: return false
	var player: Player = body
	if hp <= player.hp:
		player.hp -= hp
		queue_free()
		return true
	hp -= player.hp
	player.hp = 0
	return true

func _handle_enemy(body: Node) -> bool:
	if body is not Enemy: return false
	var enemy: Enemy = body
	if hp <= enemy.hp:
		enemy.hp -= hp
		queue_free()
		return true
	hp -= enemy.hp
	enemy.hp = 0
	return true

func is_fully_out() -> bool:
	var current_on_screen := 0
	for notifier in visible_on_screen_notifiers:
		if notifier.is_on_screen():
			current_on_screen += 1
	return current_on_screen < (len(visible_on_screen_notifiers)/2)

func collide_top_screen():
	if is_fully_out():
		return
	if direction.y > 0:
		return
	direction.y = -direction.y

func collide_bottom_screen():
	if is_fully_out():
		return
	if direction.y < 0:
		return
	direction.y = -direction.y

func collide_left_screen():
	if is_fully_out():
		return
	if direction.x > 0:
		return
	direction.x = -direction.x

func collide_right_screen():
	if is_fully_out():
		return
	if direction.x < 0:
		return
	direction.x = -direction.x
