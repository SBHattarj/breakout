extends Node


class IdGenerator:
	var next_id: int = 0
	var free_ids: Set = Set.new()
	func get_id() -> int:
		if free_ids.is_empty():
			var current_id := next_id
			next_id += 1
			return current_id
		var id: int = free_ids.values()[0]
		free_ids.delete(id)
		return id
	func return_id(id: int):
		free_ids.add(id)
class IdAwaiter:
	signal id_await(arg: Array)
	var search_id: int
	var id_index: int
	var s: Signal
	func _init(s: Signal, search_id: int, id_index: int):
		self.s = s
		self.search_id = search_id
		self.id_index = id_index
		s.connect(id_await_caller)

	func id_await_caller(...arg):
		var id = arg[id_index]
		if id != search_id: return
		s.disconnect(id_await_caller)
		arg.remove_at(id_index)
		id_await.emit(arg)

class BlockHandler:
	var block_ids := Set.new()
	var is_blocked: bool:
		get(): return not block_ids.is_empty()
	signal full_unblock
	signal on_block
	func _init(block_signal: Signal, unblock_signal: Signal):
		block_signal.connect(_on_block)
		unblock_signal.connect(_on_unblock)
	func _on_block(id: int):
		if block_ids.is_empty():
			on_block.emit()
		block_ids.add(id)
	func _on_unblock(id: int):
		block_ids.delete(id)
		if not block_ids.is_empty(): return
		full_unblock.emit()
	func wait_for_unblock() -> void:
		if not is_blocked: return
		await full_unblock
	func force_unblock() -> void:
		if not is_blocked: return
		block_ids.clear()
		full_unblock.emit()

func call_with_block(c: Callable, block_signal: Signal, unblock_signal: Signal):
	var id := global_id_generator.get_id()
	block_signal.emit(id)
	var result = await c.call()
	unblock_signal.emit(id)
	return result
	
class RegisterableAsyncQueue:
	var ids := Set.new()
	var last_id := -1
	signal end_signal(id)
	signal next_start
	var has_item: bool:
		get(): return not ids.is_empty()
	func wait_queue(id: int):
		if not has_item:
			ids.add(id)
			last_id = id
			return
		var current_last_id = last_id
		ids.add(id)
		last_id = id
		await Signals.wait_for_id(end_signal, current_last_id)
	func register(c: Callable) -> Callable:
		var wrapper := func(...args):
			var id := Signals.global_id_generator.get_id()
			await wait_queue(id)
			next_start.emit()
			var result = await c.callv(args)
			end_signal.emit(id)
			ids.delete(id)
			Signals.global_id_generator.return_id(id)
			return result
		return wrapper


func wait_for_id(s: Signal, id: int, id_index: int = 0) -> Array[Variant]:
	return await IdAwaiter.new(s, id, id_index).id_await

var global_id_generator := IdGenerator.new()

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

signal change_bgm_signal(stream: AudioStream, ease_duration: float)

func change_bgm(stream: AudioStream, ease_duration: float = 0.5):
	change_bgm_signal.emit(stream, ease_duration)
