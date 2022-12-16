extends Node2D

var cards = {}
var cardNames = []
var deck = []
var discard = []
var currCard = null
var savedCard = null
var counter = 0
var bonus = false
var lastClicked = ""
var applySucceed = false
var success = 0

var oldCard = null
var oldVals = null
var oldLogo = null


signal newCard(new_card, new_values)
signal saveCard(new_card, new_values)
signal drawCard()
signal setMods(mods)
signal hideMods()
signal discard(old_card, old_values, old_logo)
signal playerCard()
signal ace()
signal start_rolling(cardLevel)

# Called when the node enters the scene tree for the first time.
func _ready():
	var f = File.new()
	$Cards/Discard.visible = false
	f.open("res://CardsCSV.txt", File.READ)
	var line = f.get_csv_line()
	while line.size() == 5:
		cardNames.append(line[0])
		cards[line[0]] = [ceil((float(line[1]) + float(line[2]) + float(line[3]) + float(line[4]))/2), float(line[1]), float(line[2]), float(line[3]), float(line[4])]
		line = f.get_csv_line()
	f.close()
	deck = cardNames.duplicate(true)
	randomize()
	emit_signal("playerCard")
	
	# teacher mode
	$Button.visible = PlayerStats.teacherMode

func handle_draw_card_animation():
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC)
	var discardPos = $Cards/Discard.position
	var origPos = $Cards/CurrentCard.position
	if not (lastClicked == "apply" and applySucceed):
		tween.tween_callback(self, "set_disabled_buttons", [true])
		tween.tween_property($Cards/CurrentCard, "position", discardPos, 0.5)
		tween.parallel().tween_property($Cards/CurrentCard, "scale", Vector2(0.4,0.4), 0.5)
		if (oldCard):
			tween.tween_callback(self, "setDiscard")
	tween.tween_callback(self, "draw_card_animation", [origPos])

func setDiscard():
	$Cards/Discard.visible = true
	emit_signal("discard", oldCard, oldVals, oldLogo)
	
func checkIfAce():
	if (currCard.begins_with("Ace")):
		emit_signal("ace")
		$DrawButton.disabled = true
		$ApplyButton.disabled = true
	
	
func draw_card_animation(pos):
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC)
	$Cards/CurrentCard.position = Vector2(-27.5, -540)
	$Cards/CurrentCard.scale = Vector2(0.64, 0.64)
	tween.tween_callback(self, "emit_signal", ["newCard", currCard, cards[currCard]])
	tween.tween_property($Cards/CurrentCard, "position", pos, 0.5)
	tween.tween_callback(self, "set_disabled_buttons", [false])
	tween.tween_callback(self, "checkIfAce")


func _on_DrawButton_button_down():
	$ApplyButton.disabled = false
	emit_signal("drawCard")
	emit_signal("hideMods")
	if lastClicked == "draw" and currCard.begins_with("Ace") == false:
		bonus = true
	else:
		bonus = false
	
	if currCard != null and (discard.count(currCard) == 0):
		discard.append(currCard)
		oldCard = currCard
		oldVals = cards[currCard]
		oldLogo = $Cards/CurrentCard.logoFrame
	
	if deck.size() == 0:
		deck = discard.duplicate(true)
		discard.clear()
	
	currCard = deck.pop_at(randi() % deck.size())
	counter += 1
	
	# card animations for drawing a card
	handle_draw_card_animation()
		
	if counter == 8 and savedCard != null:
		$InterviewButton.disabled = false
	else:
		$InterviewButton.disabled = true
		if counter > 8 and savedCard != null:
			discard.append(savedCard)
			savedCard = null
			emit_signal("saveCard", "null", [])
			print("Missed interview")
			
	# Indicates last clicked
	lastClicked = "draw"
		

func _on_ApplyButton_button_down():
	lastClicked = "apply"
	set_disabled_buttons(true)
	emit_signal("start_rolling", cards[currCard][0], calc_roll_modifier(currCard))


func _on_InterviewButton_button_down():
	lastClicked = "interview"
	set_disabled_buttons(true)	
	emit_signal("start_rolling", cards[savedCard][0], calc_roll_modifier(savedCard))
	
func calc_roll_modifier(currCard):
	var mod = 0
	var stats = [PlayerStats.intelligence, PlayerStats.personality, PlayerStats.efficiency, PlayerStats.skills]
	var mods = []
	for i in range(4):
		if stats[i] - cards[currCard][i+1] < -3:
			mod -= 2
			mods.append(-2)
		elif stats[i] - cards[currCard][i+1] < 0:
			mod -= 1
			mods.append(-1)
		elif stats[i] - cards[currCard][i+1] > 3:
			mod += 2
			mods.append(2)
		elif stats[i] - cards[currCard][i+1] > 0:
			mod += 1
			mods.append(1)
		else:
			mods.append(0)
	emit_signal("setMods", mods)
	return mod
	

func set_disabled_buttons(disabled):
	$DrawButton.disabled = disabled
	$ApplyButton.disabled = disabled

func _on_Roller_rolling_finished(succeeded):
	$DrawButton.disabled = false
	if lastClicked == "apply":
		oldLogo = $Cards/CurrentCard.logoFrame
		applySucceed = succeeded
		if succeeded:
			success = 1
			if savedCard != null and (discard.count(savedCard) == 0):
				discard.append(savedCard)
			savedCard = currCard
			counter = 0
			handle_save_card_animations()
		
		$ApplyButton.disabled = true
	if lastClicked == "interview":
		if succeeded:
			success += 1
			counter = 0
			if (success == 3):
				print("winner!")
				get_tree().change_scene("res://Scenes/WinnerScreen.tscn")
		else:
			success = 0
			discard.append(savedCard)
			savedCard = null
			emit_signal("saveCard", "null", [])
			print("Did not meet requirements")
		$InterviewButton.disabled = true
		
func handle_save_card_animations():
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC)
	var savedPos = $Cards/SavedCard.position
	var savedScale = Vector2(0.5, 0.5)
	var origPos = $Cards/CurrentCard.position
	tween.tween_property($Cards/CurrentCard, "position", savedPos, 0.5)
	tween.parallel().tween_property($Cards/CurrentCard, "scale", savedScale, 0.5)
	tween.tween_callback(self, "save_card_animation", [origPos])


func save_card_animation(pos):
	emit_signal("saveCard", savedCard, cards[savedCard], oldLogo)
	$Cards/CurrentCard.position = pos
	$Cards/CurrentCard.scale = Vector2.ZERO
	

func _on_Button_pressed():
	if (PlayerStats.teacherMode):
		get_tree().change_scene("res://Scenes/WinnerScreen.tscn")


func _on_Stats_Display_ace_finished():
	$DrawButton.disabled = false
