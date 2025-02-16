extends RigidBody3D

@export var damage = 50
@export var blast_radius = 5.0
@export var explosion_effect: PackedScene

func _on_body_entered(body):
    explode()

func explode():
    # Нанесение урона
    var space = get_world_3d().direct_space_state
    var query = PhysicsShapeQueryParameters.new()
    query.shape = SphereShape3D.new()
    query.shape.radius = blast_radius
    
    for result in space.intersect_shape(query):
        if result.collider.has_method("take_damage"):
            result.collider.take_damage(damage)
    
    # Создание эффекта
    var effect = explosion_effect.instantiate()
    get_parent().add_child(effect)
    effect.global_transform.origin = global_transform.origin
    
    queue_free()
