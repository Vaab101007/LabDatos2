extends Node2D
var PlayerScene := preload("res://scenes/player/player.tscn")

func _ready():
	# Instanciar al jugador
	var player = PlayerScene.instantiate()
	add_child(player)

	# Colocarlo en el punto de spawn
	var spawn := $PlayerSpawn
	player.global_position = spawn.global_position

	# Activar la cámara del jugador (si la tiene)
	var cam := player.get_node_or_null("Camera2D")
	if cam:
		cam.make_current()
