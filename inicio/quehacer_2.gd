extends Node2D
# Este script maneja la funcionalidad de un botón de salida dentro de una escena,
# al presionar el botón, reproduce un sonido y oculta el nodo actual

# Se ejecuta cuando el botón de salida es presionado.
func _on_exit_button_pressed():
	# Carga y reproduce el sonido del clic del botón.
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	self.visible = false    # Oculta el nodo actual
