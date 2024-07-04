extends Node


class_name AudioLoops


enum SOUND {
	ANGRY_MOB
}


static var _singleton:AudioLoops = AudioLoops.new()


var _clipDB:Dictionary = Dictionary()

static func get_clip(soundToGet:SOUND):
	if(!_singleton._clipDB.has(int(soundToGet))):
		return null
	return _singleton._clipDB[int(soundToGet)]


func _init():
	pass
	#_registerClip(SOUND.ANGRY_MOB, 	preload("res://Resources/Audio/Menu/Loops/316640__bevibeldesign__angry-mob-loop.ogg"))


func _registerClip(index:int, clip:AudioStream, dbLevel:float = 1):
	_clipDB[index] = [clip, dbLevel]
