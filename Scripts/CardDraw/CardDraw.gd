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

# Called when the node enters the scene tree for the first time.
func _ready():
	# Replace with function body.
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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
	var accepted = apply()
	if accepted:
		lastClicked = "apply"
		success = 1
		if currCard != null and currCard != savedCard:
			pass
			#if currCard.begins_with("Ace"):
				#print("Can't save Aces")
			#else:
			if savedCard != null and (discard.count(savedCard) == 0):
				discard.append(savedCard)
			savedCard = currCard
			counter = 0
			emit_signal("saveCard", savedCard, cards[savedCard])
			_on_DrawButton_button_down()

func apply():
	var modifier = 0
	var roll
	if currCard.begins_with("Ace"):
		roll = -654
	else:
		for x in range(4):
			if cards[currCard][x + 1] - PlayerStats.stats()[x] < -4:
				modifier -= 2
			elif cards[currCard][x + 1] - PlayerStats.stats()[x] < 0:
				modifier -= 1
			elif cards[currCard][x + 1] - PlayerStats.stats()[x] >= 4:
				modifier += 1
	
		roll = randi()%20+1
		modifier += 2*int(bonus)
	if roll + modifier > cards[currCard][4]:
		print("Met requirements")
		return true
	else:
		print("Did not meet requirements")
		$ApplyButton.disabled = true
		return false
#	
	#print(deck.size())
	#print(discard.size())	
	

func _on_InterviewButton_button_down():
	lastClicked = "interview"
	var modifier = 0
	counter = 1
	for x in range(4):
		if cards[currCard][x + 1] - PlayerStats.stats()[x] < -4:
			modifier -= 2
		elif cards[currCard][x + 1] - PlayerStats.stats()[x] < 0:
			modifier -= 1
		elif cards[currCard][x + 1] - PlayerStats.stats()[x] >= 4:
			modifier += 1
			
	
	var roll = randi()%20+1
	modifier += 2*int(bonus)
	if roll + modifier > cards[currCard][4]:
		success += 1
		print("Met requirements")
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



func _on_Sprite_ace_finished():
	$DrawButton.disabled = false
