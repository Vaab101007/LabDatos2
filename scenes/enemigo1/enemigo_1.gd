extends CharacterBody2D

signal enemy_defeated
signal enemy_fully_removed

@onready var anim: AnimatedSprite2D = $animEnemigo1
@onready var attack_area: Area2D = $AttackArea   # área circular de daño

var damage := 1
var can_hit := true
var hit_cooldown := 0.5

var jugador: Node2D
var vel := 105.0
var en_rango := false
var atacando := false
var hp := 3

var is_dead := false
var can_take_damage := true
var hurt_iframes := 0.5

func _ready():
	jugador = get_tree().get_first_node_in_group("player")
	anim.stop()
	if anim.sprite_frames.has_animation("idle_down"):
		anim.play("idle_down")
	if attack_area:
		attack_area.monitoring = false
		attack_area.monitorable = true
		attack_area.collision_layer = 1 << 4
		attack_area.collision_mask  = 1 << 5
		if not attack_area.get_node_or_null("CollisionShape2D"):
			push_warning("AttackArea no tiene CollisionShape2D")
	if has_node("Area2D"):
		$Area2D.collision_mask = 1 << 0

func _physics_process(_delta):
	if not is_instance_valid(jugador) or is_dead:
		return
	if atacando:
		velocity = Vector2.ZERO
	else:
		var dir := (jugador.global_position - global_position).normalized()
		velocity = dir * vel
		if en_rango and not atacando:
			ataque()
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		en_rango = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		en_rango = false

func _play_once(name: String) -> void:
	if anim.sprite_frames.has_animation(name):
		anim.sprite_frames.set_animation_loop(name, false)
		anim.frame = 0
		anim.play(name)

func ataque() -> void:
	if is_dead:
		return
	atacando = true
	velocity = Vector2.ZERO

	if anim.sprite_frames.has_animation("Attack_preparation"):
		anim.sprite_frames.set_animation_loop("Attack_preparation", false)
		anim.frame = 0
		anim.play("Attack_preparation")
		await anim.animation_finished

	if attack_area:
		attack_area.monitoring = true

	if anim.sprite_frames.has_animation("Attack_enemy1"):
		anim.sprite_frames.set_animation_loop("Attack_enemy1", false)
		anim.frame = 0
		anim.play("Attack_enemy1")
		await anim.animation_finished

	if attack_area:
		attack_area.monitoring = false

	if not en_rango and anim.sprite_frames.has_animation("stop_attack"):
		anim.sprite_frames.set_animation_loop("stop_attack", false)
		anim.frame = 0
		anim.play("stop_attack")
		await anim.animation_finished

	atacando = false

func _on_attack_area_area_entered(area: Area2D) -> void:
	if not atacando or not can_hit:
		return
	if area.is_in_group("player_hurtbox"):
		var player := area.get_parent()
		if player and player.has_method("take_damage"):
			player.take_damage(damage)
		can_hit = false
		await get_tree().create_timer(hit_cooldown).timeout
		can_hit = true

func take_damage(dmg: int) -> void:
	if is_dead or not can_take_damage:
		return
	hp -= dmg
	print("enemigo hp:", hp)
	atacando = true
	velocity = Vector2.ZERO
	if attack_area:
		attack_area.monitoring = false
	if anim.sprite_frames.has_animation("daño"):
		anim.sprite_frames.set_animation_loop("daño", false)
		anim.frame = 0
		anim.play("daño")
		await anim.animation_finished
	can_take_damage = false
	await get_tree().create_timer(hurt_iframes).timeout
	can_take_damage = true
	atacando = false
	if hp <= 0 and not is_dead:
		_die()

func _die() -> void:
	is_dead = true # <--- Esto es clave
	emit_signal("enemy_defeated")
	atacando = false
	en_rango = false
	velocity = Vector2.ZERO
	if has_node("Area2D"):
		$Area2D.monitoring = false
	if attack_area:
		attack_area.monitoring = false
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = true
	_play_once("muerte")
	await anim.animation_finished
	_play_once("explocion")
	await anim.animation_finished
	emit_signal("enemy_fully_removed")
	queue_free()
