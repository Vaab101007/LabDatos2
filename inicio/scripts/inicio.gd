extends Node2D

func _on_exit_button_pressed() -> void:
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	get_tree().quit()


func _on_guide_button_pressed() -> void:
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	SceneTransitions.change_scene_to_file("res://inicio/guide.tscn")


func _on_lore_button_pressed() -> void:
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	SceneTransitions.change_scene_to_file("res://inicio/lore.tscn")


func _on_start_button_pressed() -> void:
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	SceneTransitions.change_scene_to_file("res://scenes/mapa/mapa.tscn")
