extends Node

onready var intelligenceButton := get_node("Board/Intelligence")
onready var personalityButton := get_node("Board/Personality")
onready var efficiencyButton := get_node("Board/Efficiency")
onready var skillsButton := get_node("Board/Skills")


var mods
var modPos

signal ace_finished()

func _ready():
	mods = [$IntelMod, $PersMod, $EffiMod, $SkillMod]
	modPos = []
	for mod in mods:
		modPos.append(mod.rect_position.y)

func _process(delta):
	if (PlayerStats):
		setText()
	
func setText():
	intelligenceButton.text = str(PlayerStats.intelligence)
	personalityButton.text = str(PlayerStats.personality)
	efficiencyButton.text = str(PlayerStats.efficiency)
	skillsButton.text = str(PlayerStats.skills)
	
	
	
func setMods(modArray):
	var positive = ImageTexture.new()
	var negative = ImageTexture.new()
	var image = Image.new()
	image.load("res://Assets/Art/Mod Indicators/Positive.png")
	positive.create_from_image(image)
	image.load("res://Assets/Art/Mod Indicators/Negative.png")
	negative.create_from_image(image)

	var modDisplays = [$IntelMod, $PersMod, $EffiMod, $SkillMod]
	for i in range(len(modArray)):
		if modArray[i] > 0:
			modDisplays[i].icon = positive
			modDisplays[i].text = "+" + str(modArray[i])
		elif modArray[i] < 0:
			modDisplays[i].icon = negative
			modDisplays[i].text = str(modArray[i])
		else:
			modDisplays[i].icon = null
			modDisplays[i].text = ""
	
	var tween := create_tween().set_trans(Tween.TRANS_ELASTIC)
	var count = 0
	for i in range(len(modDisplays)):
		tween.parallel().tween_property(modDisplays[i], "rect_position:y", modPos[i] - 32, 0.5).set_delay(0.05 * count)
		count += 1	
		
func hideMods():
	var modDisplays = [$IntelMod, $PersMod, $EffiMod, $SkillMod]
	var tween := create_tween().set_trans(Tween.TRANS_EXPO)
	for i in range(len(modDisplays)):
		tween.parallel().tween_property(modDisplays[i], "rect_position:y", modPos[i] + 32, 0.2)

	

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



func _on_Node2D_setMods(mods):
	setMods(mods)

func _on_Node2D_hideMods():
	hideMods()
