extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $animEnemigo1
@onready var detect: Area2D         = $Area2D2        # detector de cercanía
@onready var hitbox: Area2D         = $AttackArea    # daño del ataque

var speed := 80.0
var objetivo: Node2D = null
var atacando := false
var last_direction := "down"
var cooldown := 0.6

func _ready():
	# físicas del enemigo: el hitbox solo se enciende cuando golpea
	hitbox.monitoring = false
	detect.body_entered.connect(_on_detect_enter)
	detect.body_exited.connect(_on_detect_exit)
	hitbox.body_entered.connect(_on_hitbox_entered)

func _physics_process(_delta):
	if atacando:
		# cuando está atacando, no se mueve
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if objetivo:
		var dir = (objetivo.global_position - global_position)
		var distancia = dir.length()

		if distancia > 28.0:
			# Persigue al jugador
			dir = dir.normalized()
			_update_last_direction(dir)
			velocity = dir * speed
			anim.play("run_" + last_direction)
		else:
			# Detiene movimiento y ataca
			velocity = Vector2.ZERO
			_attack()
	else:
		# No hay objetivo → idle
		velocity = Vector2.ZERO
		anim.play("idle_" + last_direction)

	move_and_slide()


func _attack() -> void:
	if atacando:
		return
	atacando = true
	velocity = Vector2.ZERO

	_play_no_loop("preparacion de ataque")
	await anim.animation_finished

	hitbox.monitoring = true
	_play_no_loop("Ataque")
	await anim.animation_finished
	hitbox.monitoring = false

	_play_no_loop("Fin de ataque")
	await anim.animation_finished

	atacando = false


func _on_detect_enter(body: Node) -> void:
	if body.is_in_group("player"):
		objetivo = body

func _on_detect_exit(body: Node) -> void:
	if body == objetivo:
		objetivo = null

func _on_hitbox_entered(body: Node) -> void:
	if atacando and body.is_in_group("player") and body.has_method("_loseLife"):
		body._loseLife()

func _play_no_loop(name: String) -> void:
	if anim.sprite_frames.has_animation(name):
		anim.sprite_frames.set_animation_loop(name, false)
		anim.frame = 0
		anim.play(name)

func _update_last_direction(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		last_direction = "right" if dir.x > 0 else "left"
	else:
		last_direction = "down" if dir.y > 0 else "up"
