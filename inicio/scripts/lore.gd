extends Node2D
# Este script controla los slides dentro de una escena.
# Cada slide muestra una imagen y un label asociado, el jugador puede avanzar o retroceder con botones.

# Lista de imágenes de los diferentes slides de la presentación
var slides = [
	preload("res://inicio/image/lore1 (2).png"),
	preload("res://inicio/image/loore2.jpg"),
	preload("res://inicio/image/loore3.jpg"),
	preload("res://inicio/image/fondo33.png")
]

# Índice del slide actual
var current_slide = 0

# Lista de todos los labels en la escena
var all_labels = []

# Diccionario que asigna qué labels mostrar en cada slide
var slide_labels = {}

func _ready() -> void:
	# Aquí se definen qué labels se usan y a qué slide pertenece cada uno.
	# Inicializamos las referencias de labels
	all_labels = [$Label, $Label2, $Label3, $Label4]

	# Mapeamos los slides con sus respectivos labels
	slide_labels = {
		0: [$Label],
		1: [$Label2],
		2: [$Label3],
		3: [$Label4] 
	}

# Llamamos a la función que muestra el primer slide
	show_slide()
	
func show_slide() -> void:     # Muestra el slide actual y actualiza los textos visibles
	$SlideImage.texture = slides[current_slide]      # Cambia la imagen del nodo principal del slide

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
	$atrasButton.disabled = current_slide == 0       # Desactiva el botón "atrás" si estamos en el primer slide
	$siguienteButton.disabled = current_slide == slides.size() - 1   # Desactiva el botón "siguiente" si estamos en el último slide

# Se ejecuta cuando se presiona el botón "Atrás"
func _on_atras_button_pressed() -> void:
	if current_slide > 0:      # Retrocede un slide, si no estamos en el primero
		current_slide -= 1     # Retrocede al slide anterior
		show_slide()           # Actualiza la vista
	# Carga y reproduce sonido de clic al presionar el botón
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()

# Se ejecuta cuando se presiona el botón "Siguiente"
func _on_siguiente_button_pressed() -> void:
	if current_slide < slides.size() - 1:   # Avanza un slide, si no estamos en el último
		current_slide += 1                  # Avanza al siguiente slide
		show_slide()                        # Actualiza la vista
		# Carga y reproduce sonido de clic al presionar el botón
		AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
		AudioManager.SFXPlayer.play()
	
