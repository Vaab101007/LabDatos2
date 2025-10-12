extends Node2D
# Lista con las imágenes precargadas
var slides = [
	preload("res://inicio/image/4.png"),
	preload("res://inicio/image/5.png")
]
# Índice del slide actual que se está mostrando
var current_slide = 0

# Lista de todos los labels en la escena
var all_labels = []

# Diccionario que asigna qué labels mostrar en cada slide
var slide_labels = {}
# Se ejecuta al iniciar la escena
func _ready() -> void:
	# Inicializamos las referencias de labels
	all_labels = [$Label, $Label2, $Label3, $Label4]

	# Mapeamos los slides con sus respectivos labels
	slide_labels = {
		0: [$Label, $Label2],
		1: [$Label3, $Label4], 
	}

	show_slide()
	
func show_slide() -> void:
	# Cambia la imagen del sprite principal al slide actual
	$SlideImage.texture = slides[current_slide]

	# Ocultamos todos los labels para reiniciar la visibilidad
	for label in all_labels:
		if label:
			label.visible = false

	# Mostramos los labels que correspondan al slide actual
	if slide_labels.has(current_slide):
		for label in slide_labels[current_slide]:
			if label:
				label.visible = true

	# Botones de navegación
	$Flecha1Button.disabled = current_slide == 0 # Desactiva el botón de “anterior” si estamos en el primer slide
	$FlechaButton.disabled = current_slide == slides.size() - 1 # Desactiva el botón de “siguiente” si estamos en el último slide
# Pasamos al siguiente slide
func _on_flecha_button_pressed() -> void:
	if current_slide < slides.size() - 1: # Si no estamos en el último slide
		current_slide += 1 # Avanzamos al siguiente
		show_slide()     # Actualizamos la imagen y los labels
	# Carga y reproduce el sonido del botón
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
# Retrocedemos al slide anterior
func _on_flecha_1_button_pressed() -> void:
	if current_slide > 0:  # Si no estamos en el primer slide
		current_slide -= 1   # Retrocedemos uno
		show_slide()    # Actualizamos la imagen y los labels
		
	# Carga y reproduce el mismo sonido de clic
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
