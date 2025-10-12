extends TextureButton

func _on_pressed() -> void:
	# Carga y reproduce el sonido del clic del botón.
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	# Cambia la escena actual del juego a la pantalla inicial del juego.
	SceneTransitions.change_scene_to_file("res://inicio/inicio.tscn")
