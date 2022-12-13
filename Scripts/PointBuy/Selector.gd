extends Node2D
onready var counter = $Counter/CounterNum

signal numberChanged(currentNum, difference)

var pointTotal = 20
var pointsLeft = 20
export var currentNum = 5

func _ready():
	counter.set_frame(currentNum)

func _on_Up_Button_button_down():
	if (currentNum <= 20 and pointsLeft > 0):
		currentNum += 1
		counter.set_frame(currentNum)
		emit_signal("numberChanged", currentNum, 1)


func _on_Down_Button_button_down():
	if (currentNum > 1 and pointTotal - pointsLeft > 0):
		currentNum -= 1
		counter.set_frame(currentNum)
		emit_signal("numberChanged", currentNum, -1)


func _on_PointBuy_set_totals(points, total):
	pointsLeft = points
	pointTotal = total
