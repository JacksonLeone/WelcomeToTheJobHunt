extends Node2D

onready var intelligence = $Intelligence
onready var personality = $Personality
onready var efficiency = $Efficiency
onready var skills = $Skills

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_card():
	pass


func _on_Node2D_newCard(new_values):
	intelligence.set_frame(new_values[0])
	personality.set_frame(new_values[1])
	efficiency.set_frame(new_values[2])
	skills.set_frame(new_values[3])
