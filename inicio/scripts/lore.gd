extends Node2D

var slides = [
	preload("res://inicio/image/lore1 (2).png"),
	preload("res://inicio/image/loore2.jpg"),
	preload("res://inicio/image/loore3.jpg"),
	preload("res://inicio/image/fondo33.png")
]

var current_slide = 0

# Todos los labels en la escena
var all_labels = []

# Diccionario que asigna qué labels mostrar en cada slide
var slide_labels = {}

func _ready() -> void:
	# Inicializamos las referencias de labels
	all_labels = [$Label, $Label2, $Label3, $Label4]

	# Mapeamos los slides con sus respectivos labels
	slide_labels = {
		0: [$Label],
		1: [$Label2],
		2: [$Label3],
		3: [$Label4] 
	}

	show_slide()
	
func show_slide() -> void:
	$SlideImage.texture = slides[current_slide]

	# Ocultamos todos los labels
	for label in all_labels:
		if label:
			label.visible = false

	# Mostramos los labels que correspondan al slide actual
	if slide_labels.has(current_slide):
		for label in slide_labels[current_slide]:
			if label:
				label.visible = true

	# Botones de navegación
	$atrasButton.disabled = current_slide == 0
	$siguienteButton.disabled = current_slide == slides.size() - 1

func _on_atras_button_pressed() -> void:
	if current_slide > 0:
		current_slide -= 1
		show_slide()
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()


func _on_siguiente_button_pressed() -> void:
	if current_slide < slides.size() - 1:
		current_slide += 1
		show_slide()
		AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
		AudioManager.SFXPlayer.play()
	
