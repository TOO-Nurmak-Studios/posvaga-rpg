class_name ExplorePlayer
extends MovableCharacter

@onready var interact_area = $Area2D
@onready var interact_icon = $InteractIcon

func _ready():
	super()

	EventBus.player_move_pressed.connect(_process_movement)
	EventBus.player_sprint_pressed.connect(_process_sprint_pressed)
	EventBus.player_sprint_released.connect(_process_sprint_released)
	EventBus.player_interact_pressed.connect(_process_interaction)
	EventBus.player_interaction_ended.connect(_process_interaction_ended)


func _process(_delta):
	var target = _getInteractibleTarget()
	if target != null && target.interaction_enabled && !is_interacting:
		interact_icon.show()
	else:
		interact_icon.hide()


func _process_sprint_pressed():
	if !is_sprinting:
		is_sprinting = true
		speed = default_speed * sprint_speed_modifier
		animation_node.speed_scale *= sprint_speed_modifier
		footsteps_player.set_sprint()

func _process_sprint_released():
	is_sprinting = false
	speed = default_speed
	animation_node.speed_scale = 1
	footsteps_player.set_no_sprint()

func _process_movement(delta, new_velocity):
	velocity = new_velocity.normalized() * speed * delta;
	move_and_collide(velocity)
	play_animation(velocity)
	footsteps_player.process_for(velocity)


func _getInteractibleTarget():
	
	# достаем только интерактивные предметы
	var filter_func = func(x): return x.is_in_group("Interactible")
	# сортируем по возврастанию удаленности от игрока, чтобы выбрать ближайший
	var sort_func = func(x, y): return x.position.distance_to(self.position) < y.position.distance_to(self.position)
	
	var interactibles = interact_area.get_overlapping_bodies().filter(filter_func)
	interactibles.sort_custom(sort_func)
	
	if interactibles.size() == 0:
		return null
	
	return interactibles[0]


func _process_interaction():
	var target = _getInteractibleTarget()
	if target != null && target.interaction_enabled && !is_interacting:
		is_interacting = true
		interact_icon.hide()
		_turn_to_face_target(target)
		target.interact()

func _process_interaction_ended():
	is_interacting = false

func _turn_to_face_target(target: Node2D):
	var dir = self.position.direction_to(target.position)
	var sort_func = func(x, y): return x.distance_to(dir) < y.distance_to(dir)
	directions.sort_custom(sort_func)
	
	var ld = NormalizedDirection.LEFT.distance_to(dir)
	var rd = NormalizedDirection.RIGHT.distance_to(dir)
	var ud = NormalizedDirection.UP.distance_to(dir)
	var dd = NormalizedDirection.DOWN.distance_to(dir)
	
	face_direction(directions[0])
