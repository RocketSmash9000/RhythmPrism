extends Node2D

const HIDDEN_POS = Vector2(960, -512)
const SHOW_POS = Vector2(960, 544)
var is_hidden: bool = true
var polo_id: int = 1
var polos: Array
var lorebook

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lorebook = LogStream.new("Lorebook")
	
	polos = get_polos()
	var i = 0
	# Grabs the path for the animation and icon in the lorebook file
	# and converts it to a loadable resource.
	while i < polos.size():
		var animation: String = str(polos[i].animation)
		var icon: String = str(polos[i].icon)
		
		if animation.begins_with("res://") and icon.begins_with("res://"):
			polos[i].animation = load(animation)
			polos[i].icon = load(icon)
		else:
			polos[i].animation = null
			polos[i].icon = null
			lorebook.debug("The path for either the animation or icon for polo " + str(i + 1) + " is incorrect. Skipped.")
		i += 1
	
	update_lorebook()


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

# Opens browser links (if present) when they're clicked.
func _when_rtl_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))

## Fetches all the polos of a dictionary
func get_polos() -> Array:
	var data = GlobalVars.load_json("res://Assets/Lorebook/LorePolos.json")
	return data.get("polos", [])

## Reassigns the title, lore, animation and icon using [code]polo_id[/code].
func update_lorebook() -> void:
	$PoloName.text = polos[polo_id - 1].name
	$PoloLore.text = polos[polo_id - 1].lore
	# If the polo's animation doesn't exist, load the default
	if polos[polo_id - 1].animation != null:
		$PoloSprite.sprite_frames = polos[polo_id - 1].animation
	else:
		$PoloSprite.sprite_frames = preload("res://Assets/Unselected_polos/Unselected.tres")
	# If the polo's icon doesn't exist, load the default
	if polos[polo_id - 1].icon != null:
		$PoloIcon.texture = polos[polo_id - 1].icon
	else:
		$PoloIcon.texture = preload("res://Assets/Polos/1/PoloIcon.svg")

# Update lorebook when going right
func _when_move_right_pressed() -> void:
	polo_id += 1
	if polo_id == 21:
		polo_id = 1
	update_lorebook()

func _when_move_left_pressed() -> void:
	polo_id -= 1
	if polo_id == -1:
		polo_id = 19
	update_lorebook()
