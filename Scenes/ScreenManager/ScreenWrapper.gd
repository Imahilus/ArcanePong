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
		match _stateToSwitchTo:
			STATE.OPEN:
				if(get_child_count() > 0 && get_child(0).has_method("on_open")):
					get_child(0).on_open()
			STATE.CLOSE:
				process_mode = Node.PROCESS_MODE_DISABLED
				hide()


func open():
	_stateToSwitchTo = STATE.OPEN
	show()
	process_mode = Node.PROCESS_MODE_INHERIT


func close():
	_stateToSwitchTo = STATE.CLOSE
	if(get_child_count() > 0 && get_child(0).has_method("on_close")):
		get_child(0).on_close()


func get_current_state() -> STATE:
	return _currentState


func get_state_to_switch_to() -> STATE:
	return _stateToSwitchTo
