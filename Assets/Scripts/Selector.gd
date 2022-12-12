extends Node2D
onready var counter = $Counter/CounterNum

export var currentNum = 5

func _ready():
	counter.set_frame(currentNum)

func _on_Up_Button_button_down():
	if (currentNum <= 20):
		currentNum += 1
		counter.set_frame(currentNum)


func _on_Down_Button_button_down():
	if (currentNum > 0):
		currentNum -= 1
		counter.set_frame(currentNum)
