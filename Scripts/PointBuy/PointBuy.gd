extends Node2D

signal set_counter(pointTotal, pointsLeft)
signal set_totals(pointsLeft, pointTotal)

export var pointTotal : int
var pointsLeft : int

var intelligence
var personality
var skills
var efficiency


func _ready():
	pointsLeft = pointTotal
	emit_signal("set_counter", pointTotal, pointsLeft)
	emit_signal("set_totals", pointsLeft, pointTotal)
	
func update_counters(difference):
	pointsLeft -= difference
	emit_signal("set_counter", pointTotal, pointsLeft)
	emit_signal("set_totals", pointsLeft, pointTotal)

	
func _on_Intelligence_Selector_numberChanged(currentNum, difference):
	update_counters((difference))
	intelligence = currentNum
	PlayerStats.intelligence = intelligence

func _on_Personality_Selector_numberChanged(currentNum, difference):
	update_counters((difference))
	personality = currentNum
	PlayerStats.personality = personality


func _on_Skills_Selector_numberChanged(currentNum, difference):
	update_counters(difference)
	skills = currentNum
	PlayerStats.skills = skills


func _on_Efficiency_Selector_numberChanged(currentNum, difference):
	update_counters(difference)
	efficiency = currentNum
	PlayerStats.efficiency = efficiency
