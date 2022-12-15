extends Node

onready var intelligenceButton := get_node("Intelligence")
onready var personalityButton := get_node("Personality")
onready var efficiencyButton := get_node("Efficiency")
onready var skillsButton := get_node("Skills")

signal ace_finished()

func _process(delta):
	if (PlayerStats):
		setText()
	
func setText():
	intelligenceButton.text = str(PlayerStats.intelligence)
	personalityButton.text = str(PlayerStats.personality)
	efficiencyButton.text = str(PlayerStats.efficiency)
	skillsButton.text = str(PlayerStats.skills)


func _on_Node2D_ace():
	disableButtons(false)
	
	
func disableButtons(isDisabled):
	intelligenceButton.disabled = isDisabled;
	personalityButton.disabled = isDisabled;
	skillsButton.disabled = isDisabled;
	efficiencyButton.disabled = isDisabled;


func _on_Intelligence_pressed():
	PlayerStats.intelligence += 1
	disableButtons(true)
	emit_signal("ace_finished")


func _on_Personality_pressed():
	PlayerStats.personality += 1
	disableButtons(true)
	emit_signal("ace_finished")


func _on_Efficiency_pressed():
	PlayerStats.efficiency += 1
	disableButtons(true)
	emit_signal("ace_finished")


func _on_Skills_pressed():
	PlayerStats.skills += 1
	disableButtons(true)
	emit_signal("ace_finished")

