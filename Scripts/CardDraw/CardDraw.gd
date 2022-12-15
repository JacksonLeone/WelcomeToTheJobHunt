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
var success = 0


signal newCard(new_card, new_values)
signal saveCard(new_card, new_values)
signal playerCard()
signal ace()
signal start_rolling(cardLevel)

# Called when the node enters the scene tree for the first time.
func _ready():
	var f = File.new()
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


func _on_DrawButton_button_down():
	$ApplyButton.disabled = false
	if lastClicked == "draw" and currCard.begins_with("Ace") == false:
		bonus = true
	else:
		bonus = false
	
	lastClicked = "draw"
	if currCard != null and (discard.count(currCard) == 0):
		discard.append(currCard)
	
	if deck.size() == 0:
		deck = discard.duplicate(true)
		discard.clear()
	
	currCard = deck.pop_at(randi() % deck.size())
	counter += 1
	emit_signal("newCard", currCard, cards[currCard])
	if (currCard.begins_with("Ace")):
		emit_signal("ace")
		$DrawButton.disabled = true
		$ApplyButton.disabled = true
		
	if counter == 8 and savedCard != null:
		$InterviewButton.disabled = false
	else:
		$InterviewButton.disabled = true
		if counter > 8 and savedCard != null:
			discard.append(savedCard)
			savedCard = null
			emit_signal("saveCard", "null", [])
			print("Missed interview")
		

func _on_ApplyButton_button_down():
	lastClicked = "apply"
	set_disabled_buttons(true)
	emit_signal("start_rolling", cards[currCard][4], 0)


func _on_InterviewButton_button_down():
	lastClicked = "interview"
	set_disabled_buttons(true)	
	emit_signal("start_rolling", cards[currCard][4], 0)
	
#func calc_roll_modifier(currCard):
#	var mod = 0
#	var stats = [PlayerStats.intelligence, PlayerStats.personality, PlayerStats.efficiency, PlayerStats.skills]
#	for i in range(4):
#		if cards[currCard][i] - stats[i] >= 4:
#			mod += 2
#		if cards[currCard][i] - stats[i] >= 4:
#	return
	

func set_disabled_buttons(disabled):
	$DrawButton.disabled = disabled
	$ApplyButton.disabled = disabled


func _on_Sprite_ace_finished():
	$DrawButton.disabled = false


func _on_Roller_rolling_finished(succeeded):
	$DrawButton.disabled = false
	get_node("Roller").visible = false
	if lastClicked == "apply":
		if succeeded:
			success = 1
			if savedCard != null and (discard.count(savedCard) == 0):
				discard.append(savedCard)
			savedCard = currCard
			counter = 0
			emit_signal("saveCard", savedCard, cards[savedCard])
#			_on_DrawButton_button_down()
		else:
			pass
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
