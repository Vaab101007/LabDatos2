extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var color_rect = $dissolve_rect

func change_scene_to_file(target: String) -> void:
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play_backwards('dissolve')
	get_tree().change_scene_to_file(target)
