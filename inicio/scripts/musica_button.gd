extends TextureButton
# Este script controla un botón que sirve para activar o desactivar la música del juego.

const ICON_SOUND_ON = preload("res://inicio/buttons/musicaButton.tres")        # Ícono que se muestra cuando la música está encendida.
const ICON_SOUND_OFF = preload("res://inicio/buttons/musicaButtonPress.tres")  # Ícono que se muestra cuando la música está apagada.

func _ready():
	# Se llama a la función que actualiza el icono del botón para reflejar el estado actual del audio.
	update_icon()


func _on_pressed() -> void:      # Este método se ejecuta cuando el botón es presionado por el jugador.
	AudioManager.toggle_music()  # Llama a la función del AudioManager que alterna (mutea o desmutea) la música.
	update_icon()                # Actualiza el ícono del botón


# Esta función cambia el ícono del botón dependiendo del estado de la música.
func update_icon():
	if AudioManager.music_muted:          # Si está apagada
		texture_normal = ICON_SOUND_OFF   # Mostramos el ícono de música apagada
	else:                                 # Si no
		texture_normal = ICON_SOUND_ON    # Mostramos el ícono de música encendida
