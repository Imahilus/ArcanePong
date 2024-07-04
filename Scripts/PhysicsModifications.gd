extends Node


class_name PhysicsModifications


enum DRAG { NONE, GROUND, AIR }
const DRAG_GROUND:float = 100
const DRAG_AIR:float = 20


@export var drag:DRAG = DRAG.NONE
var _modifications:Array[Vector2] = []


func on_physics_process(delta) -> Vector2:
	var combined:Vector2 = Vector2.ZERO
	var forcesToKeep:Array[Vector2] = []
	for force in _modifications:
		combined = combined + force
		var reduction:float = 0
		match drag:
			DRAG.GROUND:
				reduction = DRAG_GROUND * delta
			DRAG.AIR:
				reduction = DRAG_AIR * delta
			_:
				pass
		reduction = clampf(reduction, 0, force.length())
		force = force - (force.normalized() * reduction)
		if(force != Vector2.ZERO):
			#We can't remove elements from an array that we're currently looping over
			forcesToKeep.append(force)
	_modifications = forcesToKeep
	
	#return the non-delta modified combined impulse
	return combined


func add_physics_modification(force:Vector2):
	_modifications.append(force)
