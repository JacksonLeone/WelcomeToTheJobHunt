extends Node2D

func _ready():
	$TecherModeCheck.pressed = PlayerStats.teacherMode

func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")


func _on_TecherModeCheck_toggled(button_pressed):
	PlayerStats.teacherMode = button_pressed
