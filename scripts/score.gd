extends CanvasLayer

@export
var score_label: Label

@export
var score := 0:
	set(val):
		score = val
		if score_label == null: return
		score_label.text = str(score)

func _ready():
	score_label.text = str(score)
	Signals.update_score_signal.connect(change_score)

func change_score(by: int):
	score += by
