extends CanvasLayer

@onready var fade_rect = $FadeRect
@onready var fade_animation = $AnimationPlayer

func fade_in(custom_speed = 1.0):
	fade_animation.play("Fade", -1, custom_speed)
	await fade_animation.animation_finished

func fade_out(custom_speed = 1.0):
	fade_animation.play("Fade_out", -1, custom_speed)

func black_out():
	fade_rect.show()
