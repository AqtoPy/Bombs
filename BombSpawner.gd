extends Node3D

@export var bomb_profiles = {
    "25mm": {
        "scene": preload("res://BombScenes/25mm.tscn"),
        "damage": 30,
        "radius": 3.0
    },
    "FAB3000": {
        "scene": preload("res://BombScenes/FAB3000.tscn"),
        "damage": 200,
        "radius": 15.0
    }
}

func spawn_bomb(type: String):
    var bomb_data = bomb_profiles[type]
    var bomb = bomb_data.scene.instantiate()
    
    bomb.position = Vector3(
        randf_range(-40, 40),
        100,
        randf_range(-40, 40)
    )
    
    bomb.damage = bomb_data.damage
    bomb.blast_radius = bomb_data.radius
    
    bomb.connect("exploded", Callable($"../DestructionSystem", "create_crater"))
    
    add_child(bomb)
