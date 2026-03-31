extends Node

@export
var hp_bar: Bar

@export
var exp_bar: Bar

func _ready() -> void:
	Signals.total_hp_changed_signal.connect(total_hp_changed)
	Signals.current_hp_changed_signal.connect(current_hp_changed)
	Signals.total_exp_changed_signal.connect(total_exp_changed)
	Signals.current_exp_changed_signal.connect(current_exp_changed)

func total_hp_changed(value: int):
	hp_bar.total = value

func current_hp_changed(value: int):
	hp_bar.current = value

func total_exp_changed(value: int):
	exp_bar.total = value

func current_exp_changed(value: int):
	exp_bar.current = value


func _on_player_game_over() -> void:
	$Control.visible = true
