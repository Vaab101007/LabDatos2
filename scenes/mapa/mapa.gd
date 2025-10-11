extends Node2D
var PlayerScene := preload("res://scenes/player/player.tscn")
var EnemyScene := preload("res://scenes/enemigo1/enemigo1.tscn") 

@onready var lupa_panel = $CanvasLayer/lupaPanel

func _ready():
	var player = PlayerScene.instantiate() # Instanciar al jugador
	add_child(player)

	var spawn := $PlayerSpawn # Colocarlo en el punto de spawn
	player.global_position = spawn.global_position
	
	var cam := player.get_node_or_null("Camera2D")
	if cam:
		cam.make_current()
	
	# var enemy = EnemyScene.instantiate() # Instanciar enemigo
	#add_child(enemy)
	#enemy.global_position = $Enemy1Spawn.global_position


func _on_lupa_button_pressed() -> void:
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	lupa_panel.visible = true


func _on_exit_button_pressed() -> void:
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	lupa_panel.visible = false
