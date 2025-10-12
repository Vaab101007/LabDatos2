extends CharacterBody2D

signal enemy_defeated # Se emite cuando el enemigo muere, antes de ser removido.
signal enemy_fully_removed # Se emite cuando el enemigo ha terminado su animación de muerte y es eliminado.


@onready var anim: AnimatedSprite2D = $animEnemigo1  # Controla las animaciones del enemigo.
@onready var attack_area: Area2D = $AttackArea   # área circular de daño.

var damage := 1  # Daño que el enemigo le genera al jugador.
var can_hit := true   # Controla si el enemigo puede golpear 
var hit_cooldown := 0.5 # Tiempo que debe esperar antes de volver a atacar.


var jugador: Node2D  # Referencia al nodo del jugador.
var vel := 105.0   # Velocidad de movimiento del enemigo.
var en_rango := false   # Indica si el jugador está dentro del rango de ataque.
var atacando := false   # Indica si el enemigo está en medio de un ataque.
var hp := 3   # Puntos de vida base del enemigo.

var is_dead := false     # Indica si el enemigo está muerto.
var can_take_damage := true   # Controla si puede recibir daño.
var hurt_iframes := 0.5  # Duración de la invulnerabilidad temporal tras recibir daño.
# Inicializa el enemigo al cargarse en la escena.
func _ready():
	jugador = get_tree().get_first_node_in_group("player") # Busca al jugador en la escena.
	anim.stop()   # Detiene cualquier animación activa.
	if anim.sprite_frames.has_animation("idle_down"):
		anim.play("idle_down")
	# Configura el área de ataque si existe
	if attack_area:
		attack_area.monitoring = false
		attack_area.monitorable = true  # Puede ser detectada por otros nodos.
		attack_area.collision_layer = 1 << 4   # Asigna su capa de colisión.
		attack_area.collision_mask  = 1 << 5   # Asigna qué capas puede detectar.
		if not attack_area.get_node_or_null("CollisionShape2D"):
			push_warning("AttackArea no tiene CollisionShape2D")  # Advertencia si falta colisionador.

	# Ajusta el área principal de detección del enemigo.
	if has_node("Area2D"):
		$Area2D.collision_mask = 1 << 0

# Controla el movimiento y ataques del enemigo en cada frame físico.
func _physics_process(_delta):
	if not is_instance_valid(jugador) or is_dead:
		return
	if atacando:
		velocity = Vector2.ZERO  # No se mueve mientras ataca.
	else:
		# Calcula la dirección hacia el jugador y se mueve.
		var dir := (jugador.global_position - global_position).normalized()
		velocity = dir * vel
		if en_rango and not atacando: # Ataca si el jugador está en rango.
			ataque()
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		en_rango = true  # Jugador entra al rango del enemigo.

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		en_rango = false   # Jugador sale del rango del enemigo.

# Función auxiliar para reproducir una animación una sola vez.
func _play_once(name: String) -> void:
	if anim.sprite_frames.has_animation(name):
		anim.sprite_frames.set_animation_loop(name, false)
		anim.frame = 0
		anim.play(name)

# Controla el comportamiento del enemigo al atacar al jugador.
func ataque() -> void:
	if is_dead:
		return
	atacando = true
	velocity = Vector2.ZERO # Se detiene para atacar.

# Animación de preparación del ataque.
	if anim.sprite_frames.has_animation("Attack_preparation"):
		anim.sprite_frames.set_animation_loop("Attack_preparation", false)
		anim.frame = 0
		anim.play("Attack_preparation")
		await anim.animation_finished

# Activa el área de daño para detectar al jugador.
	if attack_area:
		attack_area.monitoring = true

# Animación principal del ataque.
	if anim.sprite_frames.has_animation("Attack_enemy1"):
		anim.sprite_frames.set_animation_loop("Attack_enemy1", false)
		anim.frame = 0
		anim.play("Attack_enemy1")
		await anim.animation_finished

# Desactiva el área de ataque.
	if attack_area:
		attack_area.monitoring = false

# Reproduce animación de detención si el jugador ya no está en rango.
	if not en_rango and anim.sprite_frames.has_animation("stop_attack"):
		anim.sprite_frames.set_animation_loop("stop_attack", false)
		anim.frame = 0
		anim.play("stop_attack")
		await anim.animation_finished

	atacando = false  # Vuelve a estado normal.

# Se ejecuta cuando el área de ataque toca al área de daño del jugador.
func _on_attack_area_area_entered(area: Area2D) -> void:
	if not atacando or not can_hit:
		return
	if area.is_in_group("player_hurtbox"):   # Si colisiona con el área de daño del jugador.
		var player := area.get_parent()
		if player and player.has_method("take_damage"):
			player.take_damage(damage)  # Le provoca daño al jugador.
		can_hit = false     # Evita golpes múltiples instantáneos.
		await get_tree().create_timer(hit_cooldown).timeout
		can_hit = true      # Puede volver a golpear después del cooldown.

# Recibe daño, muestra animación de daño y maneja la muerte si hp ≤ 0.
func take_damage(dmg: int) -> void:
	if is_dead or not can_take_damage:
		return
	hp -= dmg
	print("enemigo hp:", hp)
	atacando = true
	velocity = Vector2.ZERO
	# Desactiva el área de ataque mientras recibe daño.
	if attack_area:  
		attack_area.monitoring = false
	# Reproduce animación de daño si existe
	if anim.sprite_frames.has_animation("daño"):
		anim.sprite_frames.set_animation_loop("daño", false)
		anim.frame = 0
		anim.play("daño")
		await anim.animation_finished
	# Periodo de invulnerabilidad tras recibir daño.
	can_take_damage = false
	await get_tree().create_timer(hurt_iframes).timeout
	can_take_damage = true
	
	atacando = false
	
	# Si la vida llega a 0, se inicia el proceso de muerte.
	if hp <= 0 and not is_dead:
		_die()

# Maneja la secuencia de muerte del enemigo.
func _die() -> void:
	is_dead = true   # Marca al enemigo como muerto.
	emit_signal("enemy_defeated")    # Emite señal indicando que fue derrotado.
	atacando = false
	en_rango = false
	velocity = Vector2.ZERO
	
	# Desactiva detecciones y colisiones.
	if has_node("Area2D"):
		$Area2D.monitoring = false
	if attack_area:
		attack_area.monitoring = false
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = true

	# Secuencia de animaciones de muerte.
	_play_once("muerte")
	await anim.animation_finished
	
	_play_once("explocion")
	await anim.animation_finished
	
	# Emite señal indicando que fue eliminado completamente y libera memoria.
	emit_signal("enemy_fully_removed")
	queue_free()
