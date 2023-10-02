class_name MovableArea2D
extends Area2D
var speed: Vector2 = Vector2(0, 0);

func move(delta: float):
	position += speed * delta
	rotation = speed.angle()
	var speed_angle = abs(rad_to_deg(speed.angle()))
	if (speed_angle >= 90 && scale.y > 0) || (speed_angle < 90 && scale.y < 0):
		var scale_t = scale
		scale_t.y *= -1
		scale = scale_t
	pass
