extends TextureButton
# Este script controla el botón de salida del juego
# Cuando el jugador presiona el botón, se reproduce un sonido y se cierra el juego.


func _on_pressed() -> void:
	# Carga y reproduce el sonido del clic del botón.
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play() # Reproduce el sonido asignado
	get_tree().quit() # Cierra completamente el juego
