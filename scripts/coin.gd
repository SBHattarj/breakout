extends CharacterBody2D
class_name Coin

signal stop_moving

@export
var speed: float = 100000

@export
var target: Player

@export
var sprite: AnimatedSprite2D

func _ready() -> void:
	sprite.play("default")

func _physics_process(delta: float) -> void:
	movement_logic()
	if move_and_slide():
		for i in range(get_slide_collision_count()):
			var collison := get_slide_collision(i)
			var collison_node := collison.get_collider()
			if collison_node != target: continue
			Signals.update_score(1)
			queue_free()
			return

func movement_logic():
	velocity = Vector2.ZERO
	if target == null: return
	var displacement_to_target := target.global_position - global_position
	var displacement_to_target_normalized := displacement_to_target.normalized()
	velocity = displacement_to_target_normalized*speed/displacement_to_target.length_squared()

func start_moving_to_player(player: Player):
	target = player
	await AsyncUtils.wait_any([
		func(): await stop_moving,
		func(): await tree_exited
	])
	target = null

func stop_moving_to_player():
	stop_moving.emit()
