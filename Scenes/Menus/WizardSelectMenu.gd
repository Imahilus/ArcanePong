extends Node2D


const GAME_SCENE:PackedScene 		= preload("res://Scenes/Game/GameContainer.tscn")
const WIZARD_CENTAURI:PackedScene 	= preload("res://Scenes/Game/Wizard.tscn")


enum WIZARD { NONE, CENTAURI, EMIRA, LAYLA, VENTURI }


var _player1Wizard:WIZARD = WIZARD.NONE
var _player2Wizard:WIZARD = WIZARD.NONE


func on_open():
	$CenterContainer/VBoxContainer/GridContainer/CentauriButton.set_pressed_no_signal(false)
	$CenterContainer/VBoxContainer/GridContainer/EmiraButton.set_pressed_no_signal(false)
	$CenterContainer/VBoxContainer/GridContainer/LaylaButton.set_pressed_no_signal(false)
	$CenterContainer/VBoxContainer/GridContainer/VenturiButton.set_pressed_no_signal(false)
	$CenterContainer/VBoxContainer/GridContainer/CentauriButton.disabled = false
	$CenterContainer/VBoxContainer/GridContainer/EmiraButton.disabled = false
	$CenterContainer/VBoxContainer/GridContainer/LaylaButton.disabled = false
	$CenterContainer/VBoxContainer/GridContainer/VenturiButton.disabled = false
	_set_button_colour(WIZARD.CENTAURI, 0)
	_set_button_colour(WIZARD.EMIRA, 0)
	_set_button_colour(WIZARD.LAYLA, 0)
	_set_button_colour(WIZARD.VENTURI, 0)
	$CenterContainer/VBoxContainer/PlayButton.disabled = true
	_player1Wizard = WIZARD.NONE
	_player2Wizard = WIZARD.NONE


func _on_wizard_select(_toggle:bool, wizardSelected:int):
	var player1Selection = int(_player1Wizard)
	var player2Selection = int(_player2Wizard)
	if(wizardSelected == player1Selection):
		_set_button_colour(_player1Wizard, 0)
		_player1Wizard = WIZARD.NONE
	elif(wizardSelected == player2Selection):
		_set_button_colour(_player2Wizard, 0)
		_player2Wizard = WIZARD.NONE
	elif(_player1Wizard == WIZARD.NONE):
		_player1Wizard = wizardSelected as WIZARD
		_set_button_colour(_player1Wizard, 1)
	elif(_player2Wizard == WIZARD.NONE):
		_player2Wizard = wizardSelected as WIZARD
		_set_button_colour(_player2Wizard, 2)
	
	if(_player1Wizard != WIZARD.NONE && _player2Wizard != WIZARD.NONE):
		if(_player1Wizard != WIZARD.CENTAURI && _player2Wizard != WIZARD.CENTAURI):
			$CenterContainer/VBoxContainer/GridContainer/CentauriButton.disabled = true
		if(_player1Wizard != WIZARD.EMIRA && _player2Wizard != WIZARD.EMIRA):
			$CenterContainer/VBoxContainer/GridContainer/EmiraButton.disabled = true
		if(_player1Wizard != WIZARD.LAYLA && _player2Wizard != WIZARD.LAYLA):
			$CenterContainer/VBoxContainer/GridContainer/LaylaButton.disabled = true
		if(_player1Wizard != WIZARD.VENTURI && _player2Wizard != WIZARD.VENTURI):
			$CenterContainer/VBoxContainer/GridContainer/VenturiButton.disabled = true
	else:
		if(_player1Wizard != WIZARD.CENTAURI && _player2Wizard != WIZARD.CENTAURI):
			$CenterContainer/VBoxContainer/GridContainer/CentauriButton.disabled = false
		if(_player1Wizard != WIZARD.EMIRA && _player2Wizard != WIZARD.EMIRA):
			$CenterContainer/VBoxContainer/GridContainer/EmiraButton.disabled = false
		if(_player1Wizard != WIZARD.LAYLA && _player2Wizard != WIZARD.LAYLA):
			$CenterContainer/VBoxContainer/GridContainer/LaylaButton.disabled = false
		if(_player1Wizard != WIZARD.VENTURI && _player2Wizard != WIZARD.VENTURI):
			$CenterContainer/VBoxContainer/GridContainer/VenturiButton.disabled = false
	
	$CenterContainer/VBoxContainer/PlayButton.disabled = _player1Wizard == WIZARD.NONE


func _on_back_button_pressed():
	ScreenManager.switch_to_screen(ScreenManager.SCREEN.MAIN_MENU)


func _on_play_button_pressed():
	var newGame:Node2D = GAME_SCENE.instantiate()
	var player1Wizard:Node2D = _create_wizard(_player1Wizard)
	var player2Wizard:Node2D
	
	var player2AI:bool = false
	if(_player2Wizard == WIZARD.NONE):
		player2AI = true
		_player2Wizard = randi_range(0, 3) as WIZARD
	player2Wizard = _create_wizard(_player2Wizard)
	if(player2AI):
		#TODO: Create an AI node that can control the other wizard
		#player2Wizard.add_child(AIPlayer.new())
		pass
	newGame.add_wizard_for_player1(player1Wizard)
	newGame.add_wizard_for_player2(player2Wizard)
	ScreenManager._singleton.find_child("GameWrapper").add_child(newGame)
	ScreenManager.switch_to_screen(ScreenManager.SCREEN.GAME)


func _create_wizard(wizardToCreate:WIZARD):
	match wizardToCreate:
		WIZARD.CENTAURI:
			return WIZARD_CENTAURI.instantiate()


func _set_button_colour(wizardSelected:WIZARD, playerNumber:int):
	var colour:Color
	match playerNumber:
		1:
			colour = Color.hex(0xff3000A0)
		2:
			colour = Color.hex(0x0050ffA0)
		_:
			colour = Color.WHITE
	
	match wizardSelected:
		WIZARD.CENTAURI:
			$CenterContainer/VBoxContainer/GridContainer/CentauriButton.self_modulate = colour
		WIZARD.EMIRA:
			$CenterContainer/VBoxContainer/GridContainer/EmiraButton.self_modulate = colour
		WIZARD.LAYLA:
			$CenterContainer/VBoxContainer/GridContainer/LaylaButton.self_modulate = colour
		WIZARD.VENTURI:
			$CenterContainer/VBoxContainer/GridContainer/VenturiButton.self_modulate = colour
