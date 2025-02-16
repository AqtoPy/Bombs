extends RigidBody3D

func _ready():
    apply_central_impulse(Vector3(
        randf_range(-10, 10),
        randf_range(5, 15),
        randf_range(-10, 10)
    )
    
    angular_velocity = Vector3(
        randf(),
        randf(),
        randf()
    ).normalized() * 5.0
