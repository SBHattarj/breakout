extends Area2D

@export
var player: Player

func _on_body_entered(body: Node2D):
	if body is not Coin: return
	var coin: Coin = body
	coin.start_moving_to_player(player)

func _on_body_exited(body: Node2D):
	if body is not Coin: return
	var coin: Coin = body
	coin.stop_moving_to_player()
