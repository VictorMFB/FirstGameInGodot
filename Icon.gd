extends Sprite2D

func _process(delta):
	position.x += 500 * delta
	var rotacion = -5 * delta
	rotation += rotacion

