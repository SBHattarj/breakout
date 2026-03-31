extends Node

signal update_score_signal(by: int)

func update_score(by: int):
	update_score_signal.emit(by)

signal current_hp_changed_signal(value: int)

func current_hp_changed(value: int):
	current_hp_changed_signal.emit(value)

signal total_hp_changed_signal(value: int)

func total_hp_changed(value: int):
	total_hp_changed_signal.emit(value)

signal current_exp_changed_signal(value: int)

func current_exp_changed(value: int):
	current_exp_changed_signal.emit(value)

signal total_exp_changed_signal(value: int)

func total_exp_changed(value: int):
	total_exp_changed_signal.emit(value)
