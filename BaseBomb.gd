extends RigidBody3D

signal exploded(position: Vector3, radius: float, bomb_type: String)

@export var bomb_type: String = "25mm"
@export var damage: int = 50
@export var blast_radius: float = 5.0
@export var explosion_effect: PackedScene

func _ready():
    contact_monitor = true  # Включить отслеживание коллизий
    max_contacts_reported = 1  # Минимум 1 контакт

func _on_body_entered(body):
    print("Контакты:", get_colliding_bodies())
    explode()

func explode():
    # Нанести урон
    var space = get_world_3d().direct_space_state
    var query = PhysicsShapeQueryParameters.new()
    query.shape = SphereShape3D.new()
    query.shape.radius = blast_radius
    query.collision_mask = 1  # Слой, на котором находятся цели
    
    for result in space.intersect_shape(query):
        var obj = result.collider
        if obj.has_method("take_damage"):
            obj.take_damage(damage)
    
    # Создать эффект
    if explosion_effect:
        var effect = explosion_effect.instantiate()
        get_parent().add_child(effect)
        effect.global_position = global_position
    
    emit_signal("exploded", global_position, blast_radius, bomb_type)
    queue_free()
