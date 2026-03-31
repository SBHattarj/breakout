extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_game_over() -> void:
	$AudioStreamPlayer.stop()
	await get_tree().process_frame
	get_tree().paused = true
	await get_tree().create_timer(3.0, true).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
