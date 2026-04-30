extends Node2D

const HIDDEN_POS = Vector2(960, -512)
const SHOW_POS = Vector2(960, 544)
var is_hidden: bool = true
var polo_id: int = 1
var polos: Array
var lorebook
var lorebook_page
var page_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lorebook = LogStream.new("Lorebook")
	
	if GlobalVars.lorebook_mode == 1:
		load_polo_lore()
		update_lorebook()
	elif GlobalVars.lorebook_mode == 2:
		lorebook_page = load_lorebook_page(page_index)


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

## Loads the lore of polos when the lorebook mode is set to 1.
func load_polo_lore() -> void:
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

## Loads the specified page of the lorebook file. Performs a few string operations, please don't alter. [br]
## Returns an array of strings, containing the title and content. The title may be empty.
func load_lorebook_page(page: int) -> Array[String]:
	var lore_file = FileAccess.open("res://Assets/Lorebook/Lorebook.txt", FileAccess.READ)
	var lore = lore_file.get_as_text().split("[page]", false, 0)
	lore = Array(lore)
	lore[page] = lore[page].replace("[/page]", "\n")
	lore[page] = lore[page].strip_edges(true, true)
	var title = lore[page].get_slice("[title]", 1).get_slice("[/title]", 0)
	lore[page] = lore[page].replace("[title]" + title + "[/title]\n", "")
	
	var result: Array[String] = [title, lore[page]]
	
	return result

func get_lorebook_pages() -> int:
	var lore_file = FileAccess.open("res://Assets/Lorebook/Lorebook.txt", FileAccess.READ)
	var lore = lore_file.get_as_text().split("[page]", false, 0)
	return lore.size()


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
	if GlobalVars.lorebook_mode == 1:
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
	elif GlobalVars.lorebook_mode == 2:
		$PoloName.text = lorebook_page[page_index]
		$PoloLore.text = lorebook_page[page_index+1]

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
