extends Node

enum State {EXPLORE, DIALOG, BATTLE}

# используем как сет, игнорируем значения
# если есть ключ, значит, такое состояние сейчас активно
var state: Dictionary = {}


const LAB_HAS_BOOK = "lab_has_book"

var vars: Dictionary = {}

var curParty: PartyState
var irlParty: PartyState
var simParty: PartyState

func set_var(name, value):
	vars[name] = value
	EventBus.game_vars_changed.emit()


func is_in_exploration():
	return state.has(State.EXPLORE)

func is_in_battle():
	return state.has(State.BATTLE)

func is_in_dialog():
	return state.has(State.DIALOG)

# это просто реализация сета (множества)
# true здесь не имеет значения, ориентируемся на наличие ключа 
func _add_state(new_state: State):
	state[new_state] = true

func _ready():
	# ождаем, что игра стартует с эксплор сцены
	_add_state(State.EXPLORE)
	
	# для эксплор сцен нет выделенных сигналов! есть только для диалогов и боёвки
	# не может быть одновременно эксплор и боёвка, они заменяют друг друга, 
	# а диалог (катсцена) идёт поверх кого-то из них
	EventBus.battle_scene_start.connect(_on_battle_start)
	EventBus.battle_scene_end.connect(_on_battle_end)
	EventBus.dialog_start.connect(_on_dialog_start)
	EventBus.dialog_finished.connect(_on_dialog_end)

func _on_battle_start():
	state.erase(State.EXPLORE)
	_add_state(State.BATTLE)
	EventBus.game_state_changed.emit()

func _on_battle_end(_ignore):
	state.erase(State.BATTLE)
	_add_state(State.EXPLORE)
	EventBus.game_state_changed.emit()

func _on_dialog_start(_ignore):
	_add_state(State.DIALOG)
	EventBus.game_state_changed.emit()

func _on_dialog_end():
	state.erase(State.DIALOG)
	EventBus.game_state_changed.emit()
