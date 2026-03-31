extends TileMapLayer
@onready var player: CharacterBody2D = $"../Player"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = round(player.position/64)*64
