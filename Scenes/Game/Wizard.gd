extends CharacterBody2D


enum PLAYER { PLAYER1, PLAYER2 }
const SPEED:float = 200
const DRAG_SPEED:float = 120


@export var _playerName:String = "Player1"
@export var _platform:Area2D
var _paddle:CharacterBody2D
#var _paddleDeltaPosition:Vector2


func _process(_delta):
	if(Input.is_action_pressed(_playerName + "_Grab")):
		if(_paddle == null):
			var bodies:Array[Node2D] = $GrabArea.get_overlapping_bodies()
			if(bodies.size() > 0):
				_paddle = bodies[0] as CharacterBody2D
				#_paddleDeltaPosition = _paddle.position - position
	else:
		_paddle = null


func _physics_process(_delta):
	var direction:Vector2 = Input.get_vector(_playerName + "_Left", _playerName + "_Right", _playerName + "_Up", _playerName + "_Down")
	
	if(_paddle != null):
		velocity = direction * DRAG_SPEED
		_paddle.velocity = direction * DRAG_SPEED
		_paddle.move_and_slide()
		_paddle.position.x = clamp(_paddle.position.x, _platform.position.x, _platform.position.x + _platform.get_node("CollisionShape2D").shape.size.x - _paddle.get_node("CollisionShape2D").shape.size.x)
		_paddle.position.y = clamp(_paddle.position.y, _platform.position.y, _platform.position.y + _platform.get_node("CollisionShape2D").shape.size.y - _paddle.get_node("CollisionShape2D").shape.size.y)
	else:
		velocity = direction * SPEED
	
	move_and_slide()
	position.x = clamp(position.x, _platform.position.x + ($CollisionShape2D.scale.x * 10), _platform.position.x + _platform.get_node("CollisionShape2D").shape.size.x - ($CollisionShape2D.scale.x * 10))
	position.y = clamp(position.y, _platform.position.y + ($CollisionShape2D.scale.y * 10), _platform.position.y + _platform.get_node("CollisionShape2D").shape.size.y - ($CollisionShape2D.scale.y * 10))
	
