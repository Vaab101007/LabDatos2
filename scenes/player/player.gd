extends CharacterBody2D
# Este script controla el comportamiento principal del jugador en el juego:


@onready var anim: AnimatedSprite2D = $anim                # Controla las animaciones del jugador
@onready var hit_right: Area2D = $ColAtaque2/HitRight      # Área de golpe hacia la derecha
@onready var hit_left: Area2D  = $ColAtaque2/HitLeft       # Área de golpe hacia la izquierda 
@onready var hit_up: Area2D    = $ColAtaque2/HitUp         # Área de golpe hacia arriba
@onready var hit_down: Area2D  = $ColAtaque2/HitDown       # Área de golpe hacia abajo
@onready var hurtbox: Area2D   = $Hurtbox                  # Área donde el jugador puede recibir daño

var is_dead := false               # Indica si el jugador está muerto
var speed := 150.0                 # Velocidad de movimiento
var last_direction := "down"       # Última dirección del movimiento 
var atacar := false                # Indica si el jugador está atacando

func _enable_hitbox(dir: String, enabled: bool) -> void:
	# Apaga todas la áreas de golpe
	hit_right.monitoring = false
	hit_left.monitoring  = false
	hit_up.monitoring    = false
	hit_down.monitoring  = false
	# enciende una if enabled
	if enabled:
		match dir:
			"right": hit_right.monitoring = true
			"left":  hit_left.monitoring  = true
			"up":    hit_up.monitoring    = true
			"down":  hit_down.monitoring  = true

func _physics_process(delta):
	if is_dead:
		return  # detiene todo si el jugador está muerto
	# Si no está atacando, permite movimiento y detectar entrada de ataque
	if !atacar:
		get_input()
		if Input.is_action_just_pressed("atacar"):
			atacar = true
			attack()       # Lanza el ataque una vez
		move_and_slide()   # ovimiento basado en velocidad

func attack() -> void:
	velocity = Vector2.ZERO                                # Detiene al jugador durante el ataque
	var anim_name: String = "attack_" + last_direction     # Elige animación según dirección
	_enable_hitbox(last_direction, true)                   # Activa el área de golpe
	if anim.sprite_frames.has_animation(anim_name):
		anim.sprite_frames.set_animation_loop(anim_name, false)
		anim.frame = 0
		anim.play(anim_name)
		await anim.animation_finished                       #Espera que termine la animación
	else:
		printerr("No existe la animación: ", anim_name)
	_enable_hitbox(last_direction, false)      # Desactiva el área de golpe
	atacar = false                             # Termina el ataque             

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if input_direction == Vector2.ZERO:
		velocity = Vector2.ZERO
		update_animation("idle")  # Estado quieto
		return
	# Determina la dirección principal del movimiento
	if abs(input_direction.x) > abs(input_direction.y):
		last_direction = "right" if input_direction.x > 0 else "left"
	else:
		last_direction = "down" if input_direction.y > 0 else "up"
	update_animation("run")              # Estado de correr
	velocity = input_direction * speed   # Aplicamos velocidad


# Actualizamos animación del jugador
func update_animation(state):
	anim.play(state + "_" + last_direction)

# Detección de colisión del ataque con enemigos
func _on_hit_area_entered(area: Area2D) -> void:
	# debug: ¿está llegando?
	print("hit area:", area.name)
	if area.is_in_group("enemy_hurtbox"):
		var enemy := area.get_parent()  # o area.owner según tu escena
		if enemy and enemy.has_method("take_damage"):
			enemy.take_damage(1)
			print("💥 daño enviado a:", enemy.name)

# Recibir daño del enemigo 
var hp := 100                # Puntos de vida
var invulnerable := false    # Indica si el jugador no puede recibir daño temporalmente
var i_frames := 1.0          # Duración de invulnerabilidad 

func take_damage(amount: int) -> void:
	if invulnerable or is_dead:
		return

	hp -= amount
	if hp < 0: hp = 0
	print("💥 Player recibió", amount, "de daño. HP:", hp)
	
	var attacker = get_tree().get_first_node_in_group("enemy")
	if attacker:
		var direction = (global_position - attacker.global_position).normalized()
		global_position += direction * 16  # Ajusta la fuerza según tu juego
	# Animación de daño direccional si existe
	var dmg_name := "daño_" + last_direction
	if anim.sprite_frames.has_animation(dmg_name):
		anim.sprite_frames.set_animation_loop(dmg_name, false)
		anim.frame = 0
		anim.play(dmg_name)

	# i-frames visuales (parpadeo rojo)
	invulnerable = true
	anim.modulate = Color(1, 0.6, 0.6)
	await get_tree().create_timer(i_frames).timeout
	anim.modulate = Color(1, 1, 1)
	invulnerable = false

	if hp <= 0 and not is_dead:   # Si la vida llega a 0, el jugador muere
		die()

func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	atacar = false

	# Apaga hurtbox e hitboxes para que no entren más golpes
	if is_instance_valid(hurtbox):
		hurtbox.monitoring = false
	_enable_hitbox(last_direction, false)

	# Animación de muerte
	var death_name := "muerte"
	if anim.sprite_frames.has_animation(death_name):
		anim.sprite_frames.set_animation_loop(death_name, false)
		anim.frame = 0
		anim.play(death_name)
		await anim.animation_finished
	
	# Cambia de escena al morir a la pantalla de reintento
	SceneTransitions.change_scene_to_file("res://inicio/again.tscn")
	print("💀 Player ha muerto")
	# despues muestra pantalla de muerte y reiniciods

# Abre una escena de ayuda o información
func _on_lupa_button_pressed() -> void:
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	SceneTransitions.change_scene_to_file("res://inicio/quehacer2.tscn")
	
