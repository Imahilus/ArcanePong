extends Node2D


class_name ScreenWrapper


enum STATE { OPEN, CLOSE }


var _currentState:STATE = STATE.CLOSE
var _stateToSwitchTo:STATE = STATE.CLOSE


func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(_delta):
	if(_stateToSwitchTo != _currentState):
		_currentState = _stateToSwitchTo
		if(_stateToSwitchTo == STATE.CLOSE):
			process_mode = Node.PROCESS_MODE_DISABLED


func open():
	_stateToSwitchTo = STATE.OPEN
	process_mode = Node.PROCESS_MODE_INHERIT


func close():
	_stateToSwitchTo = STATE.CLOSE


func get_current_state() -> STATE:
	return _currentState


func get_state_to_switch_to() -> STATE:
	return _stateToSwitchTo
