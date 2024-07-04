extends Node2D




func _on_play_button_pressed():
	ScreenManager.switch_to_screen(ScreenManager.SCREEN.WIZARD_SELECT)


func _on_settings_button_pressed():
	ScreenManager.switch_to_screen(ScreenManager.SCREEN.SETTINGS)


func _on_credits_button_pressed():
	ScreenManager.switch_to_screen(ScreenManager.SCREEN.CREDITS)


func _on_exit_button_pressed():
	get_tree().quit()
