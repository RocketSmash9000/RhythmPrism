extends Node2D

# Caches the nodes so that they're faster to access
@onready var polo_name: Label = $PoloName
@onready var polo_lore: RichTextLabel = $PoloLore
@onready var polo_sprite: AnimatedSprite2D = $PoloSprite
@onready var polo_icon: Sprite2D = $PoloIcon

# Same thing here
const DEFAULT_SPRITE := preload("res://Assets/Unselected_polos/Unselected.tres")
const DEFAULT_ICON := preload("res://Assets/Polos/1/PoloIcon.svg")
# Somehow I just discovered you can do := to assign a variable
# the type of the value you assign. How didn't I know sooner?
const HIDDEN_POS := Vector2(960, -512)
const SHOW_POS := Vector2(960, 544)

var is_hidden := true
var polo_id := 1
var polos: Array
var lorebook: LogStream
var lorebook_page: Array[String]
var lore_pages: Array = []
var page_index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lorebook = LogStream.new("Lorebook")
	
	# Load all the lore when the scene loads
	var lore_file = FileAccess.open("res://Assets/Lorebook/Lorebook.txt", FileAccess.READ)
	lore_pages = Array(lore_file.get_as_text().split("[page]", false))
	
	# Load the initial lorebook page
	match GlobalVars.lorebook_mode:
		1:
			load_polo_lore()
			update_lorebook()
		2:
			update_lorebook()

## Animates the lorebook appearing on the main menu screen
func show_lore() -> void:
	position = SHOW_POS
	var animator := create_tween()
	animator.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
	animator.set_trans(Tween.TRANS_SINE)
	animator.set_ease(Tween.EASE_OUT)
	get_parent().animate_blur()
	animator.tween_property(self, "scale:x", 1, 0.25)
	animator.tween_property(self, "scale:y", 1, 0.25)
	is_hidden = false

## Animates the lorebook disappearing on the main menu screen
func hide_lore() -> void:
	var animator := create_tween()
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
	# Grabs the path for the animation and icon in the lorebook file
	# and converts it to a loadable resource.
	for polo in polos:
		var animation := str(polo.animation)
		var icon := str(polo.icon)
		
		if animation.begins_with("res://") and icon.begins_with("res://"):
			polo.animation = load(animation)
			polo.icon = load(icon)
		else:
			polo.animation = null
			polo.icon = null
			lorebook.debug("The path for either the animation or icon for polo " + str(polo) + " is incorrect. Skipped.")

## Loads the specified page of the lorebook file. Performs a few string operations, please don't alter. [br]
## Returns an array of strings, containing the title and content. The title may be empty.
func load_lorebook_page(page: int) -> Array[String]:
	var content = lore_pages[page].strip_edges()
	
	content = content.rstrip("\n[/page]")

	var title := ""

	var regex := RegEx.new()
	regex.compile("\\[title\\](.*?)\\[/title\\]")

	var result := regex.search(content)

	if result:
		title = result.get_string(1)
		content = regex.sub(content, "", true).strip_edges()

	return [title, content]

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
	var data := GlobalVars.load_json("res://Assets/Lorebook/LorePolos.json")
	return data.get("polos", [])

## Reassigns the title, lore, animation and icon using [code]polo_id[/code].
func update_lorebook() -> void:
	if GlobalVars.lorebook_mode == 1:
		var polo = polos[polo_id - 1]
		polo_name.text = polo.name
		polo_lore.text = polo.lore
		# If the polo's animation doesn't exist, load the default
		if polo.animation != null:
			polo_sprite.sprite_frames = polo.animation
		else:
			polo_sprite.sprite_frames = DEFAULT_SPRITE
		# If the polo's icon doesn't exist, load the default
		if polo.icon != null:
			polo_icon.texture = polo.icon
		else:
			polo_icon.texture = DEFAULT_ICON
	elif GlobalVars.lorebook_mode == 2:
		lorebook_page = load_lorebook_page(page_index)
		polo_name.text = lorebook_page[0]
		polo_lore.text = lorebook_page[1]

## Updates lorebook when going right.
## Goes to the first page if the last page is reached
func _when_move_right_pressed() -> void:
	polo_id = wrapi(polo_id + 1, 0, polos.size())
	page_index = wrapi(page_index + 1, 0, lore_pages.size())
	update_lorebook()

## Updates lorebook when going left.
## Wraps correctly to the other side
func _when_move_left_pressed() -> void:
	polo_id = wrapi(polo_id - 1, 0, polos.size())
	page_index = wrapi(page_index - 1, 0, lore_pages.size())
	update_lorebook()
