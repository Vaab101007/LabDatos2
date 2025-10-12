extends CanvasLayer
# Este script controla las transiciones entre escenas usando un efecto visual de disolución.
# Utilizamos un AnimationPlayer para reproducir una animación antes y después del cambio de escena.

@onready var animation_player = $AnimationPlayer  # Se utiliza para reproducir las animaciones
@onready var color_rect = $dissolve_rect          # Se utiliza para crear el efector de disolución

# Recibe como parámetro 'target', que es la ruta del archivo de la nueva escena a la que se desea cambiar.
func change_scene_to_file(target: String) -> void:
	$AnimationPlayer.play('dissolve')            # Reproduce la animación "dissolve" en dirección normal para hacer aparecer el efecto. 
	await $AnimationPlayer.animation_finished    # Espera a que la animación termine antes de continuar
	$AnimationPlayer.play_backwards('dissolve')  # Reproduce la misma animación, pero en reversa, 
	get_tree().change_scene_to_file(target)      # Cambia la escena actual a la indicada en el parámetro 'target'.
