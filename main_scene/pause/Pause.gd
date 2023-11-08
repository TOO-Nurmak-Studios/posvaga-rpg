class_name Pause

extends CanvasLayer

var developers: Array[String] = ["Дмитрий Мажуга", "Григорий Караваев", "Даниил Белоглазов", "Полина Попова", "Екатерина Сараева"]
var actors: Array[String] = ["Полина Попова", "Виктор Ложников", "Олег Судоплатов", "Максим Большим", "Бекарыс Абуов", "Елизавета Казакова", "Тигран Манасян"]
var other_actors = "и другие..."

@onready var rect = $ColorRect
@onready var pause_button = $PauseButton
@onready var retry_button = $BattleRestartButton
@onready var credits_nurmak_list: Label = $ColorRect/CreditsNurmakList
@onready var credits_actors_list_one: Label = $ColorRect/CreditsActorsList1
@onready var credits_actors_list_two: Label = $ColorRect/CreditsActorsList2

@onready var rand = BetterRandNumGen.new()


func _ready():
	
	# костыль чтобы кнопка лишний раз не спавнилась в начале игры
	await get_tree().create_timer(2).timeout
	
	_on_game_state_change()
	
	EventBus.pause_start.connect(_on_pause_start)
	EventBus.game_state_changed.connect(_on_game_state_change)
	EventBus.pause_button_pressed.connect(_on_esc_pressed)


func _on_game_state_change():
	# странно конечно, если стейт меняется во время паузы?? но давайте выходить тогда
	rect.hide()
	_change_buttons_visibility()


func _change_buttons_visibility():
	if GameState.is_in_dialog():
		pause_button.hide()
		#retry_button.hide()
	elif GameState.is_in_battle():
		pause_button.show()
		#retry_button.show()
	elif GameState.is_in_exploration():
		pause_button.show()
		#retry_button.hide()


func _on_pause_button_pressed():
	EventBus.pause_start.emit()

func _on_back_button_pressed():
	_on_pause_finish()

func _on_esc_pressed():
	if rect.visible:
		_on_pause_finish()
	elif !GameState.is_in_dialog():
		_on_pause_start()


func _on_pause_start():
	_rearrange_credits()
	get_tree().paused = true
	pause_button.hide()
	retry_button.hide()
	rect.show()


func _on_pause_finish():
	get_tree().paused = false
	rect.hide()
	_change_buttons_visibility()
	EventBus.pause_finish.emit()


# по приколу каждый раз переставляем порядок челов
func _rearrange_credits():
	_shuffle_array(developers)
	_shuffle_array(actors)
	
	var dev_text = ""
	for dev in developers:
		dev_text += dev + "\n"
	credits_nurmak_list.text = dev_text
	
	var act_text_one = ""
	var act_text_two = ""
	for i in range(actors.size()):
		if i % 2 == 0:
			act_text_one += actors[i] + "\n"
		else:
			act_text_two += actors[i] + "\n"
	act_text_two += other_actors
	credits_actors_list_one.text = act_text_one
	credits_actors_list_two.text = act_text_two

# Fisher–Yates shuffle, or Knuth shuffle
func _shuffle_array(array):
	for i in range(array.size() - 1, 1, -1):
		var j = rand.randi_range(0, i)
		var temp = array[i]
		array[i] = array[j]
		array[j] = temp


