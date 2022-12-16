extends Node2D

export var nextGameScene : PackedScene
export var startIntelligence = 4
export var startPersonality = 4
export var startEfficiency = 4
export var startSkills = 4

func _on_New_Game_Button_button_up():
	PlayerStats.intelligence = startIntelligence
	PlayerStats.personality = startPersonality
	PlayerStats.efficiency = startEfficiency
	PlayerStats.skills = startSkills
	get_tree().change_scene(nextGameScene.resource_path)


func _on_Start_Game_Button_button_up():
	get_tree().change_scene(nextGameScene.resource_path)
