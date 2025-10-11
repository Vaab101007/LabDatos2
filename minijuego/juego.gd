extends Node2D

# Diccionario: palabra → binario real
var cipher_table = {
	"DATA": "01000100 01000001 01010100 01000001",
	"CODE": "01000011 01001111 01000100 01000101",
	"LOCK": "01001100 01001111 01000011 01001011",
	"NODE": "01001110 01001111 01000100 01000101",
	"BYTE": "01000010 01011001 01010100 01000101",
	"CYBER": "01000011 01011001 01000010 01000101 01010010"
}

var current_word = ""
var current_code = []
var estado = "VERIFICAR"  # cambia entre VERIFICAR y GENERAR

@onready var labels = [
	$TextureRect/cod1,
	$TextureRect2/cod2,
	$TextureRect3/cod3,
	$TextureRect4/cod4,
	$TextureRect5/cod5
]

@onready var text_edit = $Panel2/TextEdit
@onready var word_label = $Panel2/word
@onready var correct_panel = $correctoPanel
@onready var again_panel = $otravezPanel
@onready var lupa_panel = $lupaPanel

func _ready():
	randomize()
	correct_panel.visible = false
	again_panel.visible = false
	generar_codigo()


func generar_codigo():
	# Escoge una palabra aleatoria
	var palabras = cipher_table.keys()
	current_word = palabras[randi() % palabras.size()]
	current_code = cipher_table[current_word].split(" ")

	# Muestra el código binario en los labels dentro de los TextureRect
	for i in range(labels.size()):
		if i < current_code.size():
			labels[i].text = current_code[i]
		else:
			labels[i].text = "" # Vacía si la palabra tiene menos letras

	# Limpia campos previos
	text_edit.text = ""
	word_label.text = ""
	correct_panel.visible = false
	again_panel.visible = false
	estado = "VERIFICAR"


func _on_continue_button_pressed():
	if estado == "VERIFICAR":
		var intento = text_edit.text.strip_edges().to_upper()

		if intento == current_word:
			correct_panel.visible = true
			again_panel.visible = false
			estado = "GENERAR"
		else:
			again_panel.visible = true
			correct_panel.visible = false
	else:
		# Genera una nueva palabra cuando presiona "Siguiente"
		generar_codigo()


func _on_regresar_button_pressed() -> void:
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	SceneTransitions.change_scene_to_file("res://minijuego/juego.tscn")


func _on_lupa_button_pressed() -> void:
	lupa_panel.visible = true

func _on_texture_button_pressed() -> void:
	lupa_panel.visible = false
