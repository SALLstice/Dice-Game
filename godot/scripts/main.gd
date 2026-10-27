extends Control
## Combat and loot screens. The UI is built in code so the whole game lives in scripts for now.

var player: Creature
var monster: Creature
var loot: Loot
var kills := 0

## Die whose bomb/reroll face is waiting for a target.
var acting_die: Die
## Loot face picked on the loot screen, waiting for a face to replace.
var picked_loot: Face

var combat_screen: VBoxContainer
var monster_sprite: TextureRect
var monster_stats: Label
var monster_dice: HBoxContainer
var player_stats: Label
var player_dice: HBoxContainer
var attack_button: Button
var restart_button: Button
var log_label: Label

var loot_screen: VBoxContainer
var loot_title: Label
var loot_row: HBoxContainer
var loot_dice: VBoxContainer
var skip_button: Button


func _ready() -> void:
	_build_combat_screen()
	_build_loot_screen()
	_new_game()


func _new_game() -> void:
	player = GameData.new_player()
	kills = 0
	_spawn_monster("")


func _spawn_monster(message: String) -> void:
	monster = GameData.random_monster(kills)
	acting_die = null
	player.roll_all()
	monster.roll_all()
	attack_button.disabled = false
	restart_button.visible = false
	log_label.text = (message + " " if message else "") + "A %s appears!" % monster.display_name
	_show_combat()


# --- Combat ---------------------------------------------------------------

func _on_attack() -> void:
	acting_die = null
	var dealt := monster.take_damage(player.totals[Face.Type.ATTACK])
	var taken := player.take_damage(monster.totals[Face.Type.ATTACK])
	var msg := "You hit the %s for %d. It hits you for %d." % [monster.display_name, dealt, taken]

	if player.is_dead():
		log_label.text = msg + " You died."
		attack_button.disabled = true
		restart_button.visible = true
		_refresh_combat()
	elif monster.is_dead():
		kills += 1
		player.heal()
		_show_loot("%s The %s is dead!" % [msg, monster.display_name])
	else:
		player.heal()
		monster.heal()
		player.roll_all()
		monster.roll_all()
		log_label.text = msg
		_refresh_combat()


func _on_die_clicked(creature: Creature, die: Die) -> void:
	if player.is_dead():
		return
	if acting_die:
		if die != acting_die:
			_use_targeted_face(creature, die)
		acting_die = null
	elif creature == player:
		var face := die.current()
		if face.used:
			pass
		elif face.id == "spring":
			log_label.text = "Spring releases %d." % face.winds
			player.cash_spring(face)
		elif face.is_targeted():
			acting_die = die
			log_label.text = "Click a die to %s. Click this one again to cancel." % face.id
	_refresh_combat()


func _use_targeted_face(creature: Creature, target: Die) -> void:
	var face := acting_die.current()
	match face.id:
		"reroll":
			face.used = true
			creature.reroll(target)
			log_label.text = "Rerolled."
		"bomb":
			target.set_current(Face.new("blank", Face.Type.BLANK))
			acting_die.set_current(Face.new("blank", Face.Type.BLANK))
			log_label.text = "Boom. Both faces are blank now."
	player.calc_totals()
	monster.calc_totals()


func _show_combat() -> void:
	loot_screen.get_parent().visible = false
	combat_screen.get_parent().visible = true
	_refresh_combat()


func _refresh_combat() -> void:
	monster_sprite.texture = null if monster.is_dead() else load("res://art/monsters/%s.png" % monster.sprite)
	monster_stats.text = "%s\n%s" % [monster.display_name, _stats_text(monster)]
	player_stats.text = "You\n%s    Scrap %d/%d    Kills %d" % [_stats_text(player), player.scrap, Creature.SCRAP_PER_DIE, kills]
	_fill_dice_row(monster_dice, monster)
	_fill_dice_row(player_dice, player)


func _fill_dice_row(row: HBoxContainer, creature: Creature) -> void:
	_clear(row)
	if creature.is_dead():
		return
	for die in creature.dice:
		var view := DieView.new(die.current())
		view.set_selected(die == acting_die)
		view.clicked.connect(_on_die_clicked.bind(creature, die))
		row.add_child(view)


func _stats_text(c: Creature) -> String:
	return "HP %d/%d    ATK %d   DEF %d   HEAL %d   MAG %d" % [
		maxi(c.hp, 0), c.max_hp,
		c.totals[Face.Type.ATTACK], c.totals[Face.Type.DEFEND],
		c.totals[Face.Type.HEAL], c.totals[Face.Type.MAGIC],
	]


# --- Loot -----------------------------------------------------------------

func _show_loot(message: String) -> void:
	loot = Loot.new()
	picked_loot = null
	loot_title.text = "%s\nPick a face, then click one of your faces to replace it. Or skip and take %d scrap." % [message, loot.scrap]
	skip_button.text = "Skip (+%d scrap)" % loot.scrap
	combat_screen.get_parent().visible = false
	loot_screen.get_parent().visible = true
	_refresh_loot()


func _refresh_loot() -> void:
	_clear(loot_row)
	for face in loot.faces:
		var view := DieView.new(face)
		view.set_selected(face == picked_loot)
		view.clicked.connect(_on_loot_clicked.bind(face))
		loot_row.add_child(view)

	_clear(loot_dice)
	for die in player.dice:
		var row := HBoxContainer.new()
		for i in die.faces.size():
			var view := DieView.new(die.faces[i])
			view.clicked.connect(_on_inventory_face_clicked.bind(die, i))
			row.add_child(view)
		loot_dice.add_child(row)


func _on_loot_clicked(face: Face) -> void:
	picked_loot = null if picked_loot == face else face
	_refresh_loot()


func _on_inventory_face_clicked(die: Die, index: int) -> void:
	if picked_loot == null:
		return
	die.faces[index] = picked_loot
	_spawn_monster("Face added.")


func _on_skip() -> void:
	var bought := player.add_scrap(loot.scrap)
	var msg := "+%d scrap." % loot.scrap
	if bought > 0:
		msg += " Your scrap became a new blank die!"
	_spawn_monster(msg)


# --- UI building ----------------------------------------------------------

func _clear(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()


func _screen() -> VBoxContainer:
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for side in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 24)
	add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 16)
	margin.add_child(root)
	return root


func _button(text: String, on_pressed: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.pressed.connect(on_pressed)
	return button


func _build_combat_screen() -> void:
	combat_screen = _screen()

	var monster_row := HBoxContainer.new()
	monster_row.add_theme_constant_override("separation", 24)
	combat_screen.add_child(monster_row)

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

	combat_screen.add_child(HSeparator.new())

	player_stats = Label.new()
	combat_screen.add_child(player_stats)
	player_dice = HBoxContainer.new()
	combat_screen.add_child(player_dice)

	var buttons := HBoxContainer.new()
	combat_screen.add_child(buttons)
	attack_button = _button("Attack", _on_attack)
	buttons.add_child(attack_button)
	restart_button = _button("Restart", _new_game)
	buttons.add_child(restart_button)

	log_label = Label.new()
	log_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	combat_screen.add_child(log_label)


func _build_loot_screen() -> void:
	loot_screen = _screen()

	loot_title = Label.new()
	loot_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	loot_screen.add_child(loot_title)
	loot_row = HBoxContainer.new()
	loot_screen.add_child(loot_row)

	loot_screen.add_child(HSeparator.new())
	var dice_label := Label.new()
	dice_label.text = "Your dice"
	loot_screen.add_child(dice_label)
	loot_dice = VBoxContainer.new()
	loot_screen.add_child(loot_dice)

	skip_button = _button("Skip", _on_skip)
	skip_button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	loot_screen.add_child(skip_button)
