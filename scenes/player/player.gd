extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $anim

var speed = 150.0
var last_direction= "down"
var atacar:bool = false


func _physics_process(delta):
	if !atacar:
		get_input()
		if Input.is_action_just_pressed("atacar"):
			atacar = true
			attack() #<- lanza el ataque una vez
		move_and_slide()


func attack() -> void:
	velocity = Vector2.ZERO
	var anim_name: String = "attack_" + last_direction  # <-- tipado explícito

	# Asegura que exista y que NO tenga loop
	if anim.sprite_frames.has_animation(anim_name):
		anim.sprite_frames.set_animation_loop(anim_name, false)
		anim.frame = 0
		anim.play(anim_name)
		await anim.animation_finished
	else:
		printerr("No existe la animación: ", anim_name)

	atacar = false


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction == Vector2.ZERO:
		velocity = Vector2.ZERO
		update_animation("idle")
		return
	
	if abs(input_direction.x) > abs(input_direction.y):
		#Movimiento horizontal
		if input_direction.x > 0:
			last_direction = "right"
		else:
			last_direction = "left"
	else:
		if input_direction.y > 0:
			last_direction = "down"
		else:
			last_direction = "up"
			
			
	update_animation("run")
	velocity = input_direction * speed

func update_animation(state):
	anim.play(state + "_" + last_direction)
