extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cards = {}
var cardNames = []
var deck = []
var discard = []
var currCard = null
var savedCard = null

signal newCard(new_values)
signal saveCard(new_values)

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SaveButton_button_down():
	if currCard != null and currCard != savedCard:
		if currCard.begins_with("Ace"):
			print("Can't save Aces")
		elif savedCard != null:
			if (discard.count(savedCard) == 0):
				discard.append(savedCard)
			savedCard = currCard
			emit_signal("saveCard", cards[savedCard])
			_on_DrawButton_button_down()


func _on_DrawButton_button_down():
	if currCard != null and (discard.count(currCard) == 0):
		discard.append(currCard)
	
	if deck.size() == 0:
		deck = discard.duplicate(true)
		discard.clear()
	
	currCard = deck.pop_at(randi() % deck.size())
	#print(currCard)
	#print("Intelligence: " + str(cards[currCard][0]))
	#print("Personality: " + str(cards[currCard][1]))
	#print("Efficiency: " + str(cards[currCard][2]))
	#print("Skills: " + str(cards[currCard][3]))
	#print("Level: " + str(cards[currCard][4]))
	print(deck.size())
	print(discard.size())
	
	
	emit_signal("newCard", cards[currCard])


func _on_Node2D_saveCard(values, card):
	pass # Replace with function body.
