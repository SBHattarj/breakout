extends Node

signal update_score_signal(by: int)

func update_score(by: int):
	update_score_signal.emit(by)
