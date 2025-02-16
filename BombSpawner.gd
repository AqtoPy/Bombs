extends Node3D

class_name BombSpawner

# Все типы боеприпасов с параметрами
@export var bomb_profiles = {
    "25mm": {
        "scene": preload("res://BombScenes/25mm.tscn"),
        "damage": 35,
        "radius": 4.0,
        "spawn_rate": 3.0,
        "effect": preload("res://Effects/SmallExplosion.tscn")
    },
    "152mm": {
        "scene": preload("res://BombScenes/152mm.tscn"),
        "damage": 80,
        "radius": 8.0,
        "spawn_rate": 2.5,
        "effect": preload("res://Effects/MediumExplosion.tscn")
    },
    "shrapnel": {
        "scene": preload("res://BombScenes/ShrapnelBomb.tscn"),
        "damage": 60,
        "radius": 6.0,
        "spawn_rate": 4.0,
        "effect": preload("res://Effects/ShrapnelExplosion.tscn")
    },
    "FAB1500": {
        "scene": preload("res://BombScenes/FAB1500.tscn"),
        "damage": 150,
        "radius": 12.0,
        "spawn_rate": 1.5,
        "effect": preload("res://Effects/LargeExplosion.tscn")
    },
    "FAB3000": {
        "scene": preload("res://BombScenes/FAB3000.tscn"),
        "damage": 300,
        "radius": 20.0,
        "spawn_rate": 0.8,
        "effect": preload("res://Effects/MegaExplosion.tscn")
    }
}

# Настройки спавна
@export var spawn_area_radius: float = 45.0
@export var min_spawn_height: float = 80.0
@export var max_spawn_height: float = 120.0

var active_spawners = []

func _ready():
    setup_initial_spawners()
    start_spawning()

func setup_initial_spawners():
    for bomb_type in bomb_profiles:
        var timer = Timer.new()
        timer.name = "%s_SpawnTimer" % bomb_type
        timer.wait_time = bomb_profiles[bomb_type]["spawn_rate"]
        timer.timeout.connect(spawn_bomb.bind(bomb_type))
        add_child(timer)
        active_spawners.append(timer)

func start_spawning():
    for timer in active_spawners:
        timer.start()

func stop_spawning():
    for timer in active_spawners:
        timer.stop()

func spawn_bomb(bomb_type: String):
    if !bomb_profiles.has(bomb_type):
        push_error("Unknown bomb type: %s" % bomb_type)
        return
    
    var bomb_data = bomb_profiles[bomb_type]
    var bomb = bomb_data.scene.instantiate()
    
    # Настройка параметров
    bomb.damage = bomb_data.damage
    bomb.blast_radius = bomb_data.radius
    bomb.effect_scene = bomb_data.effect
    
    # Позиция спавна
    var spawn_pos = Vector3(
        randf_range(-spawn_area_radius, spawn_area_radius),
        randf_range(min_spawn_height, max_spawn_height),
        randf_range(-spawn_area_radius, spawn_area_radius)
    )
    
    bomb.position = spawn_pos
    bomb.rotation = Vector3(
        randf_range(-PI, PI),
        randf_range(-PI, PI),
        randf_range(-PI, PI)
    )
    
    # Соединение сигналов
    bomb.connect("exploded", Callable(self, "_on_bomb_exploded"))
    
    add_child(bomb)

func _on_bomb_exploded(position: Vector3, radius: float, bomb_type: String):
    # Обработка последствий взрыва
    var effect = bomb_profiles[bomb_type]["effect"].instantiate()
    effect.position = position
    get_parent().add_child(effect)
    
    # Вызов системы разрушений
    get_node("../DestructionSystem").create_crater(position, radius)
    
    # Имитация ударной волны
    for body in get_tree().get_nodes_in_group("physics_bodies"):
        var distance = body.global_position.distance_to(position)
        if distance < radius * 2.0:
            var force = (1.0 - (distance / (radius * 2.0))) * 500.0
            body.apply_central_impulse(
                (body.global_position - position).normalized() * force
            )

func set_spawn_rate(bomb_type: String, new_rate: float):
    if bomb_profiles.has(bomb_type):
        get_node("%s_SpawnTimer" % bomb_type).wait_time = new_rate

func adjust_difficulty(multiplier: float):
    for timer in active_spawners:
        timer.wait_time = max(0.5, timer.wait_time * multiplier)
