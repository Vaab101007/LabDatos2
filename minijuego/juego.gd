extends Node2D
# Este script controla una escena tipo "minijuego" donde el jugador debe adivinar
# qué palabra en texto corresponde a un código binario mostrado en pantalla.

# Diccionario que relaciona cada palabra con su representación binaria real.
# Cada letra se traduce a su código ASCII binario de 8 bits.
var cipher_table = {
	"DATA": "01000100 01000001 01010100 01000001",
	"CODE": "01000011 01001111 01000100 01000101",
	"LOCK": "01001100 01001111 01000011 01001011",
	"NODE": "01001110 01001111 01000100 01000101",
	"BYTE": "01000010 01011001 01010100 01000101",
	"CYBER": "01000011 01011001 01000010 01000101 01010010"
}

var current_word = ""   # Palabra seleccionada actualmente
var current_code = []   # Lista con los códigos binarios de la palabra actual
var estado = "VERIFICAR"  # cambia entre VERIFICAR y GENERAR
# VERIFICAR: el jugador debe escribir su respuesta
# GENERAR: se prepara una nueva palabra

# Referencias a los labels donde se muestra el código binario 
@onready var labels = [
	$TextureRect/cod1,
	$TextureRect2/cod2,
	$TextureRect3/cod3,
	$TextureRect4/cod4,
	$TextureRect5/cod5
]
# Referencias a los elementos del panel de juego
@onready var text_edit = $Panel2/TextEdit         # Cuadro donde el jugador escribe su respuesta
@onready var word_label = $Panel2/word            # Muestra la palabra
@onready var correct_panel = $correctoPanel       # Panel que aparece si la respuesta es correcta
@onready var again_panel = $otravezPanel          # Panel que aparece si la respuesta es incorrecta
@onready var lupa_panel = $lupaPanel              # Panel de ayuda o pista
@onready var panel = $Panel                       # Panel principal del juego

# Inicializa la escena al cargarla
func _ready():
	randomize()                         # Permite elegir palabras aleatorias diferentes cada vez
	correct_panel.visible = false       # Oculta el panel de "correcto"
	again_panel.visible = false         # Oculta el panel de "intenta otra vez"
	generar_codigo()                    # Genera el primer código binario


func generar_codigo():
	# Escoge una palabra aleatoria del diccionario y la separa en códigos binarios
	var palabras = cipher_table.keys()
	current_word = palabras[randi() % palabras.size()]
	current_code = cipher_table[current_word].split(" ")

	# Muestra el código binario en los labels dentro de los TextureRect
	for i in range(labels.size()):
		if i < current_code.size():
			labels[i].text = current_code[i]    # Asigna cada bloque binario a su label
		else:
			labels[i].text = ""     # Si hay menos letras que labels, los demás quedan vacíos

	# Limpia los campos previos
	text_edit.text = ""
	word_label.text = ""
	correct_panel.visible = false
	again_panel.visible = false
	estado = "VERIFICAR"     # Regresa al modo de verificación

# Función del botón "Continuar"
func _on_continue_button_pressed():
	if estado == "VERIFICAR":
		var intento = text_edit.text.strip_edges().to_upper()  # Obtiene y limpia el texto ingresado

		if intento == current_word:   # Si la respuesta es correcta
			correct_panel.visible = true
			again_panel.visible = false
			estado = "GENERAR"  # Cambia a modo de generar nueva palabra
		else:    
			again_panel.visible = true
			correct_panel.visible = false
	else:
		# Genera una nueva palabra cuando presiona "Siguiente"
		generar_codigo()

# Función del botón "Regresar" cuando se falla una respuesta
func _on_regresar_button_pressed() -> void:
	# Carga y reproduce el sonido del clic del botón.
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	text_edit.text = ""                 # Limpia el texto ingresado
	again_panel.visible = false         # Oculta el panel de error

# Función del botón "Lupa", que muestra el panel de ayuda o la pista visual
func _on_lupa_button_pressed() -> void:
	lupa_panel.visible = true

func _on_texture_button_pressed() -> void:
	lupa_panel.visible = false    # Cierra el panel de la lupa 

# Evento del botón "Siguiente",que pasa a otra parte o escena del juego
func _on_siguiente_button_pressed() -> void:
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	self.visible = false    # Oculta el panel actual
