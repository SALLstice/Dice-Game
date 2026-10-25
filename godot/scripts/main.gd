extends Control
## Combat screen. The UI is built in code so the whole game lives in scripts for now.

const DIE_SIZE := Vector2(64, 64)

var player: Creature
var monster: Creature

var monster_sprite: TextureRect
var monster_stats: Label
var monster_dice: HBoxContainer
var player_stats: Label
var player_dice: HBoxContainer
var attack_button: Button
var next_button: Button
var log_label: Label


func _ready() -> void:
	_build_ui()
	_new_game()


func _new_game() -> void:
	player = GameData.new_player()
	_spawn_monster()
	log_label.text = "Press Attack to trade blows."


func _spawn_monster() -> void:
	monster = GameData.random_monster()
	player.roll_all()
	monster.roll_all()
	attack_button.disabled = false
	next_button.visible = false
	log_label.text = "A %s appears!" % monster.display_name
	_refresh()


func _on_attack() -> void:
	var dealt := monster.take_damage(player.totals[Face.Type.ATTACK])
	var taken := player.take_damage(monster.totals[Face.Type.ATTACK])
	var msg := "You hit the %s for %d. It hits you for %d." % [monster.display_name, dealt, taken]

	if player.is_dead():
		msg += " You died."
		_end_fight("Restart")
	elif monster.is_dead():
		msg += " The %s is dead!" % monster.display_name
		player.heal()
		_end_fight("Next monster")
	else:
		player.heal()
		monster.heal()
		player.roll_all()
		monster.roll_all()

	log_label.text = msg
	_refresh()


func _end_fight(next_label: String) -> void:
	attack_button.disabled = true
	next_button.text = next_label
	next_button.visible = true


func _on_next() -> void:
	if player.is_dead():
		_new_game()
	else:
		_spawn_monster()


func _refresh() -> void:
	monster_sprite.texture = null if monster.is_dead() else load("res://art/monsters/%s.png" % monster.sprite)
	monster_stats.text = "%s\n%s" % [monster.display_name, _stats_text(monster)]
	player_stats.text = "You\n%s" % _stats_text(player)
	_show_dice(monster_dice, [] if monster.is_dead() else monster.dice)
	_show_dice(player_dice, player.dice)


func _stats_text(c: Creature) -> String:
	return "HP %d/%d    ATK %d   DEF %d   HEAL %d   MAG %d" % [
		maxi(c.hp, 0), c.max_hp,
		c.totals[Face.Type.ATTACK], c.totals[Face.Type.DEFEND],
		c.totals[Face.Type.HEAL], c.totals[Face.Type.MAGIC],
	]


func _show_dice(row: HBoxContainer, dice: Array) -> void:
	for child in row.get_children():
		child.queue_free()
	for die in dice:
		var face: Face = die.current()
		var rect := TextureRect.new()
		rect.texture = face.texture()
		rect.modulate = face.color()
		rect.custom_minimum_size = DIE_SIZE
		rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		row.add_child(rect)


func _build_ui() -> void:
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 24)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 16)
	margin.add_child(root)

	var monster_row := HBoxContainer.new()
	monster_row.add_theme_constant_override("separation", 24)
	root.add_child(monster_row)

	monster_sprite = TextureRect.new()
	monster_sprite.custom_minimum_size = Vector2(160, 160)
	monster_sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	monster_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	monster_row.add_child(monster_sprite)

	var monster_info := VBoxContainer.new()
	monster_row.add_child(monster_info)
	monster_stats = Label.new()
	monster_info.add_child(monster_stats)
	monster_dice = HBoxContainer.new()
	monster_info.add_child(monster_dice)

	root.add_child(HSeparator.new())

	player_stats = Label.new()
	root.add_child(player_stats)
	player_dice = HBoxContainer.new()
	root.add_child(player_dice)

	var buttons := HBoxContainer.new()
	root.add_child(buttons)
	attack_button = Button.new()
	attack_button.text = "Attack"
	attack_button.pressed.connect(_on_attack)
	buttons.add_child(attack_button)
	next_button = Button.new()
	next_button.pressed.connect(_on_next)
	buttons.add_child(next_button)

	log_label = Label.new()
	log_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(log_label)
