extends Panel

func mostrar_por_segundos(segundos):
	visible = true
	$Timer.wait_time = segundos
	$Timer.one_shot = true
	$Timer.start()


func _on_timer_timeout() -> void:
	visible = false
