extends CharacterBody2D

const move_speed = 100
const max_speed = 150

const jump_height = -500
const up = Vector2(0, -1)

const gravity = 15

@onready var knight = $Knight
@onready var animation_player = $AnimationPlayer

var motion = Vector2()
var can_double_jump = false  # Variable para rastrear si el jugador puede realizar un doble salto

func _physics_process(delta):
	motion.y += gravity
	var friction = false
	
	if Input.is_action_pressed("ui_right") and is_on_floor():
		knight.flip_h = false
		animation_player.play("Run")
		motion.x = min(motion.x + move_speed, max_speed)
	elif Input.is_action_pressed("ui_left") and is_on_floor():
		knight.flip_h = true
		animation_player.play("Run")
		motion.x = max(motion.x - move_speed, -max_speed)
	elif is_on_floor():
		animation_player.play("Idle")
		friction = true
	
	# Lógica de salto y doble salto
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			motion.y = jump_height
			animation_player.play("Roll")
			can_double_jump = true  # Permitir el doble salto después del primer salto
		elif can_double_jump:
			motion.y = jump_height
			animation_player.play("Roll")
			can_double_jump = false  # Desactivar el doble salto después de usarlo

	# Lógica para aplicar fricción en el suelo
	if is_on_floor():
		if friction:
			motion.x = lerp(motion.x, 0.0, 0.5)
	else:
		if friction:
			motion.x = lerp(motion.x, 0.0, 0.01)
	
	# Mueve al personaje
	velocity = motion
	move_and_slide()

	# Restablecer el doble salto al tocar el suelo
	if is_on_floor():
		can_double_jump = false
