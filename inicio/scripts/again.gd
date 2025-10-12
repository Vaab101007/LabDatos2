extends Node2D


func _on_again_button_pressed() -> void:
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	SceneTransitions.change_scene_to_file("res://inicio/inicio.tscn")
