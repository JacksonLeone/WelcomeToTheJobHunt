extends Node2D

onready var card = $Background
onready var title = $Name
onready var level = $Level
onready var intelligence = $Intelligence
onready var personality = $Personality
onready var efficiency = $Efficiency
onready var skills = $Skills
onready var logo = $Logo
onready var logoFrame = 0
onready var aces = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	if self.name == "CurrentCard" or self.name == "SavedCard":
		card.set_frame(3)

	

func set_background(frame):
	card.set_frame(frame)
	

func _on_Node2D_newCard(new_name, new_values):
	if new_name.begins_with("Ace"):
		set_background(1)
		logo.set_frame(0)
	elif card.get_frame() != 0:
		set_background(0)
	if new_name.begins_with("Ace") == false:
		logoFrame = randi()%16+1
		logo.set_frame(logoFrame)
	else:
		logoFrame = -1
	title.text = new_name
	level.set_frame(new_values[0])
	intelligence.set_frame(new_values[1])
	personality.set_frame(new_values[2])
	efficiency.set_frame(new_values[3])
	skills.set_frame(new_values[4])
	

func _on_Node2D_discard(new_name, new_values, new_logo):
	print(new_logo)
	print("Aces" + str(aces))
	if aces < 1 or new_logo != -1:
		logo.set_frame(new_logo)
	else:
		aces = 0
	title.text = new_name
	level.set_frame(new_values[0])
	intelligence.set_frame(new_values[1])
	personality.set_frame(new_values[2])
	efficiency.set_frame(new_values[3])
	skills.set_frame(new_values[4])


func _on_Node2D_saveCard(new_name, new_values, new_logo):
	if new_name == "null":
		set_background(3)
		title.text = " "
		intelligence.set_frame(0)
		personality.set_frame(0)
		efficiency.set_frame(0)
		skills.set_frame(0)
		level.set_frame(0)
		logo.set_frame(0)
		
	else:
		if card.get_frame() != 0:
			set_background(0)
		title.text = new_name
		level.set_frame(new_values[0])
		intelligence.set_frame(new_values[1])
		personality.set_frame(new_values[2])
		efficiency.set_frame(new_values[3])
		skills.set_frame(new_values[4])
		logo.set_frame(new_logo)
		


func _on_Node2D_playerCard():
	if card.get_frame() != 0:
		set_background(0)
	title.text = PlayerStats.player
	intelligence.set_frame(PlayerStats.intelligence)
	personality.set_frame(PlayerStats.personality)
	efficiency.set_frame(PlayerStats.efficiency)
	skills.set_frame(PlayerStats.skills)




func _on_Node2D_ace():
	aces += 1
	print(aces)
