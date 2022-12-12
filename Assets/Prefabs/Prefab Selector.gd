extends Node2D
onready var counter = $Counter/CounterNum

var currentNum = 0

func _ready():
	counter.set_frame(0)

func _on_Up_Button_button_down():
	pass # Replace with function body.
