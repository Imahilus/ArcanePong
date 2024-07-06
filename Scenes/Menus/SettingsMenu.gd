extends Node2D


func _ready():
	#$CenterContainer/VBoxContainer/ScrollContainer/VBoxContainer
	pass


func _on_back_button_pressed():
	ScreenManager.switch_to_screen(ScreenManager.SCREEN.MAIN_MENU)
