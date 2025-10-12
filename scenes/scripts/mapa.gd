extends CanvasLayer
# Este script controla la capa de interfaz de usuario, suu propósito es mantener fija la posición del 
# contenido en pantalla, evitando que se mueva con la cámara u otros elementos del juego.

func _process(delta):
	# Asegura que el CanvasLayer permanezca estático
	# y no se vea afectado por el movimiento de la cámara o transformaciones del nodo padre.
	offset = Vector2.ZERO
