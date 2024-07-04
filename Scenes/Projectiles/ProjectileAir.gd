extends CharacterBody2D


const SPEED = 300.0


var angle:float = 0


func _physics_process(delta):
	velocity = Vector2.from_angle(angle) * SPEED * delta
	var collision:KinematicCollision2D = move_and_collide(velocity)
	if(collision != null):
		queue_free()
