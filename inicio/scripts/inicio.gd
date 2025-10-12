extends Node2D
# Este script controla los botones principales del menú de inicio del juego.
func _on_guide_button_pressed() -> void:
	# Asigna el sonido del clic de botón al reproductor de efectos de sonido.
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()   # Reproduce el sonido al presionar el botón.
	# Esto redirige al jugador a una pantalla con instrucciones o información de ayuda.
	SceneTransitions.change_scene_to_file("res://inicio/guide.tscn")


func _on_lore_button_pressed() -> void:
	# Asigna y reproduce el sonido del clic del botón.
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	# Cambia la escena actual a la escena de la historia del juego.
	SceneTransitions.change_scene_to_file("res://inicio/lore.tscn")


func _on_start_button_pressed() -> void:
	# Asigna y reproduce el sonido del clic del botón.
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	# Cambia la escena actual a la escena de inicio del juego.
	SceneTransitions.change_scene_to_file("res://inicio/start.tscn")
