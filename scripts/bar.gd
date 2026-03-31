@tool
extends Control
class_name Bar

@export
var base_bar: Control

@export
var display_bar: Control

@export
var current_display: Label
@export
var total_display: Label

@export
var total: int:
	set(val):
		total = val
		if not all_nodes_presant(): return
		total_display.text = str(total)
		set_current_fraction()

@export
var current: int:
	set(val):
		current = val
		if not all_nodes_presant(): return
		set_current_fraction()

func set_current_fraction():
		current_display.text = str(current)
		var total_length := base_bar.size.x
		var fraction := float(current)/total
		display_bar.size.x = fraction*total_length

func all_nodes_presant() -> bool:
	if base_bar == null: return false
	if display_bar == null: return false
	if current_display == null: return false
	if total_display == null: return false
	return true
