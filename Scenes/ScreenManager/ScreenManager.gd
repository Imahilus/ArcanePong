extends Node


class_name ScreenManager


enum SCREEN { NONE, MAIN_MENU, SETTINGS, WIZARD_SELECT, GAME, CREDITS }


var currentScreen:SCREEN = SCREEN.NONE
var screenToSwitchTo:SCREEN = SCREEN.GAME


func _process(_delta):
	if(screenToSwitchTo != SCREEN.NONE):
		var currentScreenNode:ScreenWrapper = _get_wrapper_node(currentScreen)
		var screenNodeToSwitchTo:ScreenWrapper = _get_wrapper_node(screenToSwitchTo)
		if(currentScreen != SCREEN.NONE && screenToSwitchTo != currentScreen && currentScreenNode.get_state_to_switch_to() != ScreenWrapper.STATE.CLOSE):
			currentScreenNode.close()
		elif(screenToSwitchTo != currentScreen && (currentScreen == SCREEN.NONE || currentScreenNode.get_current_state() == ScreenWrapper.STATE.CLOSE)):
			currentScreen = screenToSwitchTo
			screenToSwitchTo = SCREEN.NONE
			if(screenNodeToSwitchTo != null):
				screenNodeToSwitchTo.open()


func _get_wrapper_node(screenToGetNodeFor:SCREEN) -> ScreenWrapper:
	match screenToGetNodeFor:
		SCREEN.MAIN_MENU:
			return $MainMenuWrapper
		SCREEN.SETTINGS:
			return $SettingsWrapper
		SCREEN.WIZARD_SELECT:
			return $WizardSelectWrapper
		SCREEN.GAME:
			return $GameWrapper
		SCREEN.CREDITS:
			return $CreditsWrapper
	return null
