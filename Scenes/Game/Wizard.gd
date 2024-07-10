extends CharacterBody2D


enum PLAYER { PLAYER1, PLAYER2 }
const SPEED:float = 200
const DRAG_SPEED:float = 120

const PROJECTILE_AIR:PackedScene = preload("res://Scenes/Projectiles/ProjectileAir.tscn")
const PROJECTILE_FIREBALL:PackedScene = preload("res://Scenes/Projectiles/ProjectileFireball.tscn")

@export var _playerName:String = "Player1"
@export var _platform:Area2D
@export var _paddle:CharacterBody2D
var _isGrabbingPaddle:bool = false


func _process(_delta):
	if(Input.is_action_just_pressed(_playerName + "_Grab")):
		if(!_isGrabbingPaddle):
			var bodies:Array[Node2D] = $GrabArea.get_overlapping_bodies()
			_isGrabbingPaddle = bodies.has(_paddle)
	elif(!Input.is_action_pressed(_playerName + "_Grab")):
		_isGrabbingPaddle = false
	
	if(!_isGrabbingPaddle && Input.is_action_just_pressed(_playerName + "_Projectile1")):
		if($CastArea.get_overlapping_bodies().has(_paddle)):
			var projectile:CharacterBody2D = PROJECTILE_FIREBALL.instantiate()
			var halfProjectileWidth:float = projectile.get_node("CollisionShape2D").shape.radius
			
			#We're going to fire based on the centerpoint of the paddle
			var paddleCenterPoint:Vector2 = Vector2(_paddle.position.x + (_paddle.get_node("CollisionShape2D").shape.size.x / 2), _paddle.position.y + (_paddle.get_node("CollisionShape2D").shape.size.y / 2))
			#Get the angle of the wizard to the paddle
			var firingAngle:float = position.angle_to_point(paddleCenterPoint)
			#Make sure we're going to fire from the correct side of the paddle (the projectile should always be on the opposite side of the paddle)
			var direction:float = (paddleCenterPoint.x - position.x) / abs(paddleCenterPoint.x - position.x)
			#The firing point always needs to be at least half the width of the projectile out from the paddle to prevent a collision
			var paddleFiringPoint:Vector2 = Vector2(paddleCenterPoint.x + ( direction * ((_paddle.get_node("CollisionShape2D").shape.size.x / 2) + halfProjectileWidth )), paddleCenterPoint.y)
			
			projectile.position = paddleFiringPoint
			projectile.angle = firingAngle
			get_parent().add_child(projectile)


func _physics_process(delta):
	var direction:Vector2 = Input.get_vector(_playerName + "_Left", _playerName + "_Right", _playerName + "_Up", _playerName + "_Down")
	
	var bumped:Vector2 = $PhysicsModifications.on_physics_process(delta)
	if(bumped != Vector2.ZERO):
		_isGrabbingPaddle = false
	
	if(_isGrabbingPaddle):
		#If a paddle is being dragged; it has to be moved first, or the player can bump into it
		velocity = direction * DRAG_SPEED
		_paddle.velocity = direction * DRAG_SPEED
		_paddle.move_and_slide()
		#Restrict the paddle from leaving the platform rectangle
		_paddle.position.x = clamp(_paddle.position.x, _platform.position.x, _platform.position.x + _platform.get_node("CollisionShape2D").shape.size.x - _paddle.get_node("CollisionShape2D").shape.size.x)
		_paddle.position.y = clamp(_paddle.position.y, _platform.position.y, _platform.position.y + _platform.get_node("CollisionShape2D").shape.size.y - _paddle.get_node("CollisionShape2D").shape.size.y)
	elif(direction != Vector2.ZERO):
		velocity = (direction * SPEED) + bumped
	else:
		velocity = bumped
	
	if direction == Vector2.ZERO:
		$Sprite.play("idle")
	else:
		$Sprite.play("run")
		if direction[0] < 0:
			$Sprite.flip_h = true
		elif direction[0] > 0:
			$Sprite.flip_h = false
	
	move_and_slide()
	#Restrict the wizard from leaving the platform rectangle
	position.x = clamp(position.x, _platform.position.x + $CollisionShape2D.shape.radius, _platform.position.x + _platform.get_node("CollisionShape2D").shape.size.x - $CollisionShape2D.shape.radius)
	position.y = clamp(position.y, _platform.position.y + $CollisionShape2D.shape.radius, _platform.position.y + _platform.get_node("CollisionShape2D").shape.size.y - $CollisionShape2D.shape.radius)
	
