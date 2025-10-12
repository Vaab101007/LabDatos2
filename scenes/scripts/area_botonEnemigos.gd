extends Area2D

var EnemyScene = preload("res://scenes/enemigo1/enemigo1.tscn")
var zonas_completadas := {1: false, 2: false, 3: false, 4: false, 5: false, 6: false}
var juego_finalizado := false

# --- agrega este flag ---
var puede_activar_nodo_central := false
# --- shape_idx del nodo central (ajústalo si es otro número) ---
var shape_idx_nodo_central := 0 # por defecto parece ser el último CollisionShape2D (ajusta el número según el orden en tu escena)
# Diccionario que define cada zona, con el máximo de enemigos y el nodo de spawn correspondiente
var zonas := {
	1: {"max_enemigos": 3, "spawn": "Enemy1Spawn"},
	2: {"max_enemigos": 1, "spawn": "Enemy1Spawn2"},
	3: {"max_enemigos": 4, "spawn": "Enemy1Spawn3"},
	4: {"max_enemigos": 7, "spawn": "Enemy1Spawn4"},
	5: {"max_enemigos": 6, "spawn": "Enemy1Spawn5"},
	6: {"max_enemigos": 8, "spawn": "Enemy1Spawn6"},
}
# Diccionarios que guardan el estado de cada zona, cuántosenemigos se generaron, cuántos están vivos y cuántos se eliminaron
var enemigos_generados := {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0}
var enemigos_vivos := {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0}
var enemigos_removidos := {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0}
# Marca si la zona ya fue activada por el jugador
var zona_activada := {1: false, 2: false, 3: false, 4: false, 5: false, 6: false}
# Activa la detección de clics en las colisiones, se ejecuta al iniciar el nodo
func _ready():
	set_pickable(true) # Permite recibir eventos de clic en las colisiones
	print("Area2D lista. Esperando clic en shape_idx=1,2,3,4,5,6")
# Se ejecuta cuando el jugador hace clic sobre alguna zona o nodo central.
func _input_event(viewport, event, shape_idx):
	print("Input event recibido. shape_idx:", shape_idx, "zona_activada:", zona_activada)
	if event is InputEventMouseButton and event.pressed:
		# Si es una zona normal, maneja enemigos
		if zonas.has(shape_idx) and !zona_activada[shape_idx]:
			print("Zona activada por clic en shape_idx:", shape_idx)
			zona_activada[shape_idx] = true
			generar_un_enemigo(shape_idx)
		# Si es el nodo central
		elif shape_idx == shape_idx_nodo_central:
			if puede_activar_nodo_central:
				mostrar_pantalla_victoria()
			else:
				print("Aún no puedes activar el nodo central")
# Generamos una instancia de enemigo en la zona indicada, si no se ha alcanzado el máximo.
func generar_un_enemigo(shape_idx):
	var zona = zonas[shape_idx]
	print("Intentando generar enemigo. generados:", enemigos_generados[shape_idx], "max:", zona["max_enemigos"])
	if enemigos_generados[shape_idx] < zona["max_enemigos"]:
		var root = get_parent().get_parent()  # Referencia al nodo principal del mapa
		var spawn_marker = root.get_node(zona["spawn"]) # Buscamos el marcador de spawn
		print("Spawn marker encontrado:", spawn_marker)
		print("Posición del marker:", spawn_marker.global_position if spawn_marker else "NO ENCONTRADO")
		if spawn_marker:
			# Instanciamos un nuevo enemigo en el punto de spawn
			var enemy_instance = EnemyScene.instantiate()
			enemy_instance.global_position = spawn_marker.global_position
			# Conectamos las señales del enemigo para detectar su derrota y eliminación
			enemy_instance.connect("enemy_defeated", Callable(self, "_on_enemy_defeated").bind(shape_idx))
			enemy_instance.connect("enemy_fully_removed", Callable(self, "_on_enemy_fully_removed").bind(shape_idx))
			# Agrega el enemigo a la escena
			root.add_child(enemy_instance)
			# Actualizamos contadores
			enemigos_generados[shape_idx] += 1
			enemigos_vivos[shape_idx] += 1
			print("Enemigo generado:", enemigos_generados[shape_idx], "Enemigos vivos:", enemigos_vivos[shape_idx])
		else:
			print("ERROR: No se encontró el marker", zona["spawn"], "Revisa la jerarquía y el nombre.")
	else:
		print("Ya se generaron todos los enemigos de esta zona.")
# Se ejecuta cuando un enemigo es derrotado, para actualizar el contador y generar el siguiente.
func _on_enemy_defeated(shape_idx):
	print("Señal enemy_defeated recibida en zona", shape_idx)
	enemigos_vivos[shape_idx] -= 1
	print("Enemigos vivos tras muerte:", enemigos_vivos[shape_idx])
	# Si aún faltan enemigos por generar, creamos el siguiente
	if enemigos_generados[shape_idx] < zonas[shape_idx]["max_enemigos"]:
		print("Generando el siguiente enemigo automáticamente en zona", shape_idx, "...")
		generar_un_enemigo(shape_idx)
# Cada zona puede tener un tipo de escena diferente como un minijuego o una pregunta
var escenas_por_zona := {
	1: preload("res://minijuego/juego.tscn"),
	2: preload("res://pantallasPreguntas/preg1.tscn"),
	3: preload("res://pantallasPreguntas/preg2.tscn"),
	4: preload("res://minijuego/juego.tscn"),
	5: preload("res://pantallasPreguntas/preg3.tscn"),
	6: preload("res://pantallasPreguntas/preg4.tscn"),
}
# Se ejecuta cuando un enemigo ha sido completamente eliminado de la escena.
func _on_enemy_fully_removed(shape_idx):
	enemigos_removidos[shape_idx] += 1
	print("Enemigos removidos tras muerte en zona", shape_idx, ":", enemigos_removidos[shape_idx])
	# Si ya se eliminaron todos los enemigos de la zona, la zona es ganada
	if enemigos_removidos[shape_idx] == zonas[shape_idx]["max_enemigos"]:
		print("¡Ganaste la zona", shape_idx, "realmente!")
		# Reiniciamos los contadores de esa zona
		enemigos_generados[shape_idx] = 0
		enemigos_vivos[shape_idx] = 0
		enemigos_removidos[shape_idx] = 0
		zona_activada[shape_idx] = false
		zonas_completadas[shape_idx] = true  # Marcamos la zona como completada
# Mostramos la escena asociada (pregunta o minijuego)
		var escena = escenas_por_zona[shape_idx].instantiate()

		# Agregamos la escena al CanvasLayer (Overlay)
		var overlay = get_tree().get_current_scene().get_node("Overlay")
		overlay.add_child(escena)
		# Conectamos la señal del minijuego cuando se complete
		escena.connect("minijuego_completado", Callable(self, "_on_minijuego_completado").bind(shape_idx))
		# Si todas las zonas se completan, se muestra mensaje final y se activa el nodo central
		if _todas_zonas_completas() and not juego_finalizado:
			juego_finalizado = true
			_mostrar_mensaje_final()
			_activar_nodo_central()
# Devuelve true si todas las zonas ya fueron completadas.
func _todas_zonas_completas():
	for key in zonas_completadas.keys():
		if not zonas_completadas[key]:
			return false
	return true
# Mostramos un mensaje en pantalla invitando al jugador a activar el nodo central.	
func _mostrar_mensaje_final():
	var overlay = get_tree().get_current_scene().get_node("Overlay")
	var label = Label.new()
	label.text = "¡Dirígete al nodo central y activa la palanca para ganar!"
	label.name = "MensajeFinal"
	label.set_anchors_preset(Control.PRESET_CENTER)
	overlay.add_child(label)
# Permite hacer clic en el nodo central para así finalizar el juego.
func _activar_nodo_central():
	puede_activar_nodo_central = true
	print("Nodo central ACTIVADO, ahora puedes darle click.")
# Mostramos la pantalla de victoria final del juego
func mostrar_pantalla_victoria():
	var win_scene = preload("res://inicio/win.tscn").instantiate()
	var overlay = get_tree().get_current_scene().get_node("Overlay")
	overlay.add_child(win_scene)
	# Opcional: eliminar el mensaje final si existe
	if overlay.has_node("MensajeFinal"):
		overlay.get_node("MensajeFinal").queue_free()
		
# Llamamos a esta función cuando se completa un minijuego asociado a una zona.
# Marca la zona como completada y, si todas están listas, activa el nodo central.
func _on_minijuego_completado(shape_idx):
	zonas_completadas[shape_idx] = true
	if _todas_zonas_completas() and not juego_finalizado:
		juego_finalizado = true
		_mostrar_mensaje_final()
		_activar_nodo_central()
