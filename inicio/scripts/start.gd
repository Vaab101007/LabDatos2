extends Node2D
# En este script cuando el botón es presionado, reproduce un sonido y realiza una transición a otra escena.

func _on_button_pressed() -> void:
	# Carga y reproduce el sonido del clic del botón.
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	# Cambia la escena actual del juego
	SceneTransitions.change_scene_to_file("res://inicio/quehacer.tscn")
