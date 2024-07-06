extends Node


class_name AudioPlayer


static var _singleton:AudioPlayer


enum AudioAlbums { CLIP, LOOP }
var _loops:Dictionary = Dictionary()


func _init():
	_singleton = self


static func stop_all_loops():
	for loop:AudioStreamPlayer in _singleton._loops:
		loop.stop()
		loop.queue_free()
	_singleton.loops.clear()


static func play_clip(sound:AudioClips.SOUND, bus:String = "UI"):
	_singleton._play_clip(sound, bus)


static func play_loop(sound:AudioLoops.SOUND, bus:String = "Ambient"):
	var loopId:int = (int(sound) * 10) + int(AudioAlbums.LOOP)
	if(!_singleton._loops.has(loopId)):
		var clipBundle = AudioLoops.get_clip(sound)
		if(clipBundle != null):	
			if(!_singleton._loops.has(loopId)):
				var player = _singleton._play_loop(clipBundle, bus)
				if(player != null):
					_singleton._loops[loopId] = player


static func stop_loop(loopId:int):
	if(_singleton._loops.has(loopId)):
		var player = _singleton._loops[loopId]
		player.stop()
		player.get_parent().remove_child(player)
		_singleton._loops.erase(loopId)
		player.queue_free()


func _play_clip(sound:AudioClips.SOUND, bus:String):
	var clipBundle = AudioClips.get_clip(sound)
	if(clipBundle != null):
		var player:AudioStreamPlayer = AudioStreamPlayer.new()
		player.add_to_group("Audio")
		player.bus = bus
		player.stream = clipBundle[0]
		player.volume_db = clipBundle[1]
		$AudioStreamPlayers.add_child(player)
		player.play()
		player.finished.connect(clean_stopped_players)


func _play_loop(clipBundle, bus:String) -> AudioStreamPlayer:
	if(clipBundle != null):
		var player:AudioStreamPlayer = AudioStreamPlayer.new()
		player.add_to_group("Audio")
		player.bus = bus
		player.stream = clipBundle[0]
		player.volume_db = clipBundle[1]
		$AudioStreamPlayers.add_child(player)
		player.play()
		return player
	return null


func clean_stopped_players():
	for child in get_tree().get_nodes_in_group("Audio"):
		var player = child as AudioStreamPlayer
		if(player != null && !player.playing):
			player.get_parent().remove_child(player)
			player.queue_free()
