extends Node2D

func _on_exit_button_pressed():
	AudioManager.SFXPlayer.stream = preload("res://inicio/audio/button-305770.mp3")
	AudioManager.SFXPlayer.play()
	self.visible = false 
