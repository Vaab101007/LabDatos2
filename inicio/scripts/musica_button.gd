extends TextureButton

const ICON_SOUND_ON = preload("res://inicio/buttons/musicaButton.tres")
const ICON_SOUND_OFF = preload("res://inicio/buttons/musicaButtonPress.tres")

func _ready():
	update_icon()
	connect("pressed", Callable(self, "_on_pressed"))


func _on_pressed() -> void:
	AudioManager.toggle_music()
	update_icon()

func update_icon():
	if AudioManager.music_muted:
		texture_normal = ICON_SOUND_OFF
	else:
		texture_normal = ICON_SOUND_ON
