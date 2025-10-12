extends Node2D

# Se ejecuta automáticamente cuando el jugador presiona el botón “Again”.
func _on_again_button_pressed() -> void:
	
	# Reproduce el efecto de sonido del botón
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	# Cambia la escena actual por la escena principal (inicio del juego).
	SceneTransitions.change_scene_to_file("res://inicio/inicio.tscn")
