extends RigidBody3D

func apply_force(force: Vector3):
    apply_central_impulse(force)
