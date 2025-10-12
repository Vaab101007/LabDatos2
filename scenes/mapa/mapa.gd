extends Node2D
# Este script controla la escena principal del mapa del juego,
# se encarga de instanciar al jugador en su punto de aparición (spawn),
# configurar la cámara y manejar la visualización del panel de ayuda (lupa).
var PlayerScene := preload("res://scenes/player/player.tscn")      # Precarga la escena del jugador para poder instanciarla dinámicamente en el mapa.
var EnemyScene := preload("res://scenes/enemigo1/enemigo1.tscn")   # Precarga la escena del enemigo

# Muestra información o ayuda visual sobre el mapa.
@onready var lupa_panel = $CanvasLayer/lupaPanel

func _ready():    # Aquí se crea e inserta el jugador dentro del mapa.
	var player = PlayerScene.instantiate() # Instanciar al jugador
	add_child(player)                      # Agrega al jugador como hijo del nodo actual.

# Colocar al jugador en el punto de spawn
	var spawn := $PlayerSpawn                           # Obtiene el nodo marcador de spawn del jugador.
	player.global_position = spawn.global_position      # Asigna su posición inicial.
	
	# Activamos la cámara del jugador para que siga al personaje.
	var cam := player.get_node_or_null("Camera2D")      # Busca la cámara dentro del jugador.
	if cam:
		cam.make_current()                              # Hace que esta cámara sea la activa en el juego.
	
	# var enemy = EnemyScene.instantiate() # Instanciar enemigo
	#add_child(enemy)
	#enemy.global_position = $Enemy1Spawn.global_position

# Función que muestra un panel con información o pistas visuales para el jugador.
func _on_lupa_button_pressed() -> void:
	# Carga y reproduce el sonido del clic del botón.
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	lupa_panel.visible = true    # Muestra el panel de lupa en pantalla.

# Se ejecuta al presionar el botón de "salir" dentro del panel de lupa.
func _on_exit_button_pressed() -> void:
	# Carga y reproduce el sonido del clic al cerrar el panel.
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	lupa_panel.visible = false   # Oculta el panel de lupa.
