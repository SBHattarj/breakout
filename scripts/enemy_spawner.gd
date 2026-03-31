extends Node2D

@export
var enemy_scenes: Array[PackedScene] = []

@export
var enemy_level: int = 0

@export
var player: Player

@export
var enemy_distance := 700.0

@export
var max_enemies := 10

@export
var additional_spawn_location: Node2D

func _ready() -> void:
	spawn_enemy.call_deferred()

func spawn_enemy():
	if player == null:
		return
	#if get_child_count() >= max_enemies:
		#return
	var enemy_position_relative := Vector2.from_angle(randf_range(0, 2*PI)) * enemy_distance
	var enemy_position :=  player.global_position + enemy_position_relative
	var new_enemy: Enemy = enemy_scenes[enemy_level].instantiate()
	add_child(new_enemy)
	new_enemy.player = player
	new_enemy.additionals_spawn_location = additional_spawn_location
	new_enemy.global_position = enemy_position
	new_enemy.rotation = (-enemy_position_relative).angle()
