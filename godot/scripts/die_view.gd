class_name DieView
extends PanelContainer
## Shows one face (a die's showing face, or a loose loot face) and reports clicks.

signal clicked

const SIZE := Vector2(64, 64)

var _style := StyleBoxFlat.new()


func _init(face: Face) -> void:
	_style.bg_color = Color.TRANSPARENT
	_style.set_border_width_all(3)
	add_theme_stylebox_override("panel", _style)
	set_selected(false)
	tooltip_text = face.description()

	var icon := TextureRect.new()
	icon.texture = face.texture()
	icon.modulate = face.color()
	if face.used:
		icon.modulate.a = 0.35
	icon.custom_minimum_size = SIZE
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(icon)

	if face.id == "spring":
		var badge := Label.new()
		badge.text = str(face.winds)
		badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		badge.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		badge.add_theme_constant_override("outline_size", 6)
		badge.add_theme_color_override("font_outline_color", Color.BLACK)
		badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(badge)


func set_selected(on: bool) -> void:
	_style.border_color = Color.YELLOW if on else Color.TRANSPARENT


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit()
