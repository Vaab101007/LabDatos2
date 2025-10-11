extends Area2D

var EnemyScene = preload("res://scenes/enemigo1/enemigo1.tscn")

var zonas := {
	1: {"max_enemigos": 3, "spawn": "Enemy1Spawn"},
	2: {"max_enemigos": 1, "spawn": "Enemy1Spawn2"},
	3: {"max_enemigos": 4, "spawn": "Enemy1Spawn3"},
	4: {"max_enemigos": 7, "spawn": "Enemy1Spawn4"},
	5: {"max_enemigos": 6, "spawn": "Enemy1Spawn5"},
	6: {"max_enemigos": 8, "spawn": "Enemy1Spawn6"},
}

var enemigos_generados := {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0}
var enemigos_vivos := {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0}
var enemigos_removidos := {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0}
var zona_activada := {1: false, 2: false, 3: false, 4: false, 5: false, 6: false}

func _ready():
	set_pickable(true)
	print("Area2D lista. Esperando clic en shape_idx=1,2,3,4,5,6")

func _input_event(viewport, event, shape_idx):
	print("Input event recibido. shape_idx:", shape_idx, "zona_activada:", zona_activada)
	if event is InputEventMouseButton and event.pressed:
		if zonas.has(shape_idx) and !zona_activada[shape_idx]:
			print("Zona activada por clic en shape_idx:", shape_idx)
			zona_activada[shape_idx] = true
			generar_un_enemigo(shape_idx)

func generar_un_enemigo(shape_idx):
	var zona = zonas[shape_idx]
	print("Intentando generar enemigo. generados:", enemigos_generados[shape_idx], "max:", zona["max_enemigos"])
	if enemigos_generados[shape_idx] < zona["max_enemigos"]:
		var root = get_parent().get_parent()
		var spawn_marker = root.get_node(zona["spawn"])
		print("Spawn marker encontrado:", spawn_marker)
		print("Posición del marker:", spawn_marker.global_position if spawn_marker else "NO ENCONTRADO")
		if spawn_marker:
			var enemy_instance = EnemyScene.instantiate()
			enemy_instance.global_position = spawn_marker.global_position
			enemy_instance.connect("enemy_defeated", Callable(self, "_on_enemy_defeated").bind(shape_idx))
			enemy_instance.connect("enemy_fully_removed", Callable(self, "_on_enemy_fully_removed").bind(shape_idx))
			root.add_child(enemy_instance)
			enemigos_generados[shape_idx] += 1
			enemigos_vivos[shape_idx] += 1
			print("Enemigo generado:", enemigos_generados[shape_idx], "Enemigos vivos:", enemigos_vivos[shape_idx])
		else:
			print("ERROR: No se encontró el marker", zona["spawn"], "Revisa la jerarquía y el nombre.")
	else:
		print("Ya se generaron todos los enemigos de esta zona.")

func _on_enemy_defeated(shape_idx):
	print("Señal enemy_defeated recibida en zona", shape_idx)
	enemigos_vivos[shape_idx] -= 1
	print("Enemigos vivos tras muerte:", enemigos_vivos[shape_idx])
	if enemigos_generados[shape_idx] < zonas[shape_idx]["max_enemigos"]:
		print("Generando el siguiente enemigo automáticamente en zona", shape_idx, "...")
		generar_un_enemigo(shape_idx)

func _on_enemy_fully_removed(shape_idx):
	enemigos_removidos[shape_idx] += 1
	print("Enemigos removidos tras muerte en zona", shape_idx, ":", enemigos_removidos[shape_idx])
	if enemigos_removidos[shape_idx] == zonas[shape_idx]["max_enemigos"]:
		print("¡Ganaste la zona", shape_idx, "realmente!")
		enemigos_generados[shape_idx] = 0
		enemigos_vivos[shape_idx] = 0
		enemigos_removidos[shape_idx] = 0
		zona_activada[shape_idx] = false
