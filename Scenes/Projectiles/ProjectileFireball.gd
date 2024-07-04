extends CharacterBody2D


const SPEED = 450.0


var angle:float = 0
var _velocity:Vector2
var bounces:int = 2
var explosionPower = 400


func _ready():
	_velocity = Vector2.from_angle(angle) * SPEED
	AudioPlayer.play_clip(AudioClips.SOUND.FIRE_PROJECTILE)


func _physics_process(delta):
	velocity = (_velocity + $PhysicsModifications.on_physics_process(delta)) * delta
	rotation = velocity.angle()
	var collision:KinematicCollision2D = move_and_collide(velocity)
	if(collision != null):
		if(collision.get_collider().name != "Paddle"):
			_explode()
			bounces -= 1
			$ExplosionFire.emitting = true
		if(bounces < 0):
			collision_layer = 0
			collision_mask = 0
			$AnimatedSprite2D.hide()
			_velocity = Vector2.ZERO
		else:
			_velocity = velocity.bounce(collision.get_normal()).normalized() * SPEED
	if(bounces < 0 && $ExplosionFire.emitting == false):
		queue_free()


func _explode():
	AudioPlayer.play_clip(AudioClips.SOUND.FIRE_EXPLOSION)
	var bodies:Array[Node2D] = $ExplosionRadius.get_overlapping_bodies()
	for body in bodies:
		if(body == self || body is StaticBody2D || body.name == "Paddle"):
			continue
		elif(body.has_node("PhysicsModifications")):
			var node:PhysicsModifications = body.get_node("PhysicsModifications")
			var forceMultiplier:float = clampf(1.0 - (position.distance_to(body.position) / $CollisionShape2D.shape.radius), 0.2, 1)
			if(forceMultiplier > 0):
				node.add_physics_modification(Vector2.from_angle(position.angle_to_point(body.position)) * explosionPower * forceMultiplier)
