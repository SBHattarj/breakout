extends Node
class_name BGMHolder

@export
var stream: AudioStream

@export
var ease_in: float = 0.0

@export
var start_immediately: bool = true

func start_bgm():
	Signals.change_bgm(stream, ease_in)

func _ready() -> void:
	start_bgm.call_deferred()
