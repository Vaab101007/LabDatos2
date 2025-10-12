extends TextureButton
# Este script controla el botón de salida del juego
# Cuando el jugador presiona el botón, se reproduce un sonido y se cierra el juego.


func _on_pressed() -> void:
	# Asigna el archivo de audio al reproductor de efectos de sonido del AudioManager.
	# Este sonido corresponde al clic del botón
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play() # Reproduce el sonido asignado
	get_tree().quit() # Cierra completamente el juego
