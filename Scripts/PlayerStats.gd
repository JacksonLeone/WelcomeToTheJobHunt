extends Node2D
var player = "Player"
var intelligence = 4
var personality = 4
var efficiency = 4
var skills = 4

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func stats():
	return [intelligence, personality, efficiency, skills]
