extends Node2D
# Este script controla las acciones de dos botones dentro de una escena,
# cada botón reproduce un sonido al presionarse y luego cambia a una escena diferente.

# Se ejecuta cuando el primer botón es presionado.
func _on_button_pressed() -> void:
	# Carga y reproduce el sonido del clic del botón.
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	# Cambia la escena actual a la escena del mapa principal del juego.
	SceneTransitions.change_scene_to_file("res://scenes/mapa/mapa.tscn")

# Se ejecuta cuando el segundo botón es presionado.
func _on_button_2_pressed() -> void:
	# Carga y reproduce el sonido del clic del botón.
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	# Cambia la escena actual hacia la pantalla de inicio.
	SceneTransitions.change_scene_to_file("res://inicio/start.tscn")
