extends Node2D

const HIDDEN_POS = Vector2(960, -512)
const SHOW_POS = Vector2(960, 544)
var is_hidden: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

## Animates the lorebook appearing on the main menu screen
func show_lore() -> void:
	position = SHOW_POS
	var animator = create_tween()
	animator.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	animator.set_trans(Tween.TRANS_SINE)
	animator.set_ease(Tween.EASE_OUT)
	get_parent().animate_blur()
	animator.tween_property(self, "scale:x", 1, 0.25)
	animator.tween_property(self, "scale:y", 1, 0.25)
	is_hidden = false

## Animates the lorebook disappearing on the main menu screen
func hide_lore() -> void:
	var animator = create_tween()
	animator.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	animator.set_trans(Tween.TRANS_SINE)
	animator.set_ease(Tween.EASE_OUT)
	animator.tween_property(self, "scale:y", 0.01, 0.25)
	animator.tween_property(self, "scale:x", 0.01, 0.25)
	get_parent().animate_unblur()
	animator.tween_property(self, "position", HIDDEN_POS, 0.0)
	is_hidden = true


func _when_lore_button_pressed() -> void:
	if is_hidden:
		show_lore()
	else:
		hide_lore()


func _when_close_pressed() -> void:
	hide_lore()
