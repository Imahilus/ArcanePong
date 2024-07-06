extends Node


class_name AudioClips


enum SOUND {
	FIRE_PROJECTILE,
	FIRE_EXPLOSION
}


static var _singleton:AudioClips = AudioClips.new()


var _clipDB:Dictionary = Dictionary()

static func get_clip(soundToGet:SOUND):
	if(!_singleton._clipDB.has(int(soundToGet))):
		return null
	return _singleton._clipDB[int(soundToGet)]


func _init():
	pass
	_registerClip(SOUND.FIRE_PROJECTILE, 	preload("res://Resources/Audio/Clips/magic_elemental_fire_44.wav"))
	_registerClip(SOUND.FIRE_EXPLOSION, 	preload("res://Resources/Audio/Clips/magic_elemental_fire_33.wav"))


func _registerClip(index:int, clip:AudioStream, dbLevel:float = 1):
	_clipDB[index] = [clip, dbLevel]
