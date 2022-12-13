extends Node2D

export var nextGameScene : PackedScene

func _on_New_Game_Button_button_up():
	get_tree().change_scene(nextGameScene.resource_path)


func _on_Start_Game_Button_button_up():
	get_tree().change_scene(nextGameScene.resource_path)
