extends Node2D

signal rolling_finished(suceeded)

var active = false
onready var timer = $"Roll Time"
var cardLevel = 20
var modifier = 0
var successful = false
var roll = 0

func _ready():
	$D20.scale = Vector2.ZERO
	$D20.rotation = -30.0
	$D20/Result/Success.scale = Vector2.ZERO
	$D20/Result/Failure.scale = Vector2.ZERO


func _process(delta):
	if active:
		roll = randi()%20+1
		get_node("D20/Number").text = str(roll)


func check_win():
#	for x in range(4):
#		if cardLevel - PlayerStats.stats()[x] < -4:
#			modifier -= 2
#		elif cardLevel - PlayerStats.stats()[x] < 0:
#			modifier -= 1
#		elif cardLevel - PlayerStats.stats()[x] >= 4:
#			modifier += 1
#
#		roll = randi()%20+1
	
	var tween := create_tween().set_trans(Tween.TRANS_ELASTIC)
	var success = false
	print(roll)
	if roll + modifier > cardLevel:
		print("Met requirements")
		tween.tween_property($D20/Result/Success, "scale", Vector2(1.0, 1.0), 1.0).set_delay(0.5)
		tween.tween_property($D20/Result/Success, "scale", Vector2.ZERO, 1.0).set_delay(0.5)
		success = true
	else:
		print("Did not meet requirements")
		tween.tween_property($D20/Result/Failure, "scale", Vector2(1.0, 1.0), 1.0).set_delay(0.5)
		tween.tween_property($D20/Result/Failure, "scale", Vector2.ZERO, 1.0).set_delay(0.5)
	tween.tween_property($D20, "rotation_degrees", -30.0, 0.5)
	tween.parallel().tween_property($D20, "scale", Vector2.ZERO, 0.5)
	tween.tween_callback(self, "emit_signal", ["rolling_finished", success])
		

func _on_Timer_timeout():
	active = false
	check_win()
	
func start_roll():
	$D20.scale = Vector2.ZERO
	$D20.rotation = -30.0
	$D20/Result/Success.scale = Vector2.ZERO
	$D20/Result/Failure.scale = Vector2.ZERO
	var tween := create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($D20, "rotation_degrees", 0.0, 1)
	tween.parallel().tween_property($D20, "scale", Vector2(0.6, 0.6), 1.0)
	tween.parallel().tween_callback(self, "start_timer")

func start_timer():
	timer.start()
	active = true

func _on_Node2D_start_rolling(level, mod):
	self.visible = true
	cardLevel = level
	modifier = mod
	start_roll()

