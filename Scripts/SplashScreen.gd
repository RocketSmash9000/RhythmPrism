extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animate_entry(0.5)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_fullscreen"): # Toggles fullscreen
		if DisplayServer.window_get_mode() == 3: # 3 = fullscreen enabled
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else: # If it's not 3, enable fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _when_credits_pressed() -> void:
	var animator = create_tween()
	animator.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	animator.set_trans(Tween.TRANS_CUBIC)
	animator.set_ease(Tween.EASE_OUT)
	animator.set_parallel(true)
	animator.tween_property($Container, "material:shader_parameter/blur_amount", 2, 0.5)
	animator.tween_property($Credits_screen, "position", Vector2(960, 512), 0.5)
	animator.play()


func _when_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func animate_entry(animation_time: float) -> void:
	var animator = create_tween()
	animator.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	animator.set_trans(Tween.TRANS_CUBIC)
	animator.set_ease(Tween.EASE_OUT)
	animator.set_parallel(true)
	animator.tween_property($Container/SubViewport/Shadow, "position", Vector2(960, 909), animation_time)
	animator.tween_property($Container/SubViewport/Shadow2, "position", Vector2(960, 133), animation_time)
	animator.tween_property($Container/SubViewport/Play, "position", Vector2(880, 864), animation_time)
	animator.tween_property($Container/SubViewport/Credits, "position", Vector2(40, 40), animation_time)
	animator.play()


func _when_close_pressed() -> void:
	var animator = create_tween()
	animator.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	animator.set_trans(Tween.TRANS_CUBIC)
	animator.set_ease(Tween.EASE_OUT)
	animator.set_parallel(true)
	animator.tween_property($Container, "material:shader_parameter/blur_amount", 0, 0.5)
	animator.tween_property($Credits_screen, "position", Vector2(960, 1824), 0.5)
	animator.play()
