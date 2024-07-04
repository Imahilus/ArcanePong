extends RigidBody2D


func _physics_process(delta):
	var velocity:Vector2 = $PhysicsModifications.on_physics_process(delta) * delta
	move_and_collide(velocity)
