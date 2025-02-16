extends CharacterBody3D

@export var base_speed = 5.0
@export var base_jump = 4.5
@export var max_health = 100

var current_speed = 5.0
var current_jump = 4.5
var health = max_health:
    set(value):
        health = clamp(value, 0, max_health)
        update_movement_stats()

var coins = 0
var debuff_level = 0

func _ready():
    update_movement_stats()

func update_movement_stats():
    var speed_multiplier = 1.0
    var jump_multiplier = 1.0
    
    if health <= 25:
        speed_multiplier = 0.4
        jump_multiplier = 0.3
        debuff_level = 3
    elif health <= 50:
        speed_multiplier = 0.6
        jump_multiplier = 0.5
        debuff_level = 2
    elif health <= 75:
        speed_multiplier = 0.8
        jump_multiplier = 0.7
        debuff_level = 1
    else:
        debuff_level = 0
    
    current_speed = base_speed * speed_multiplier * (1 + 0.2 * Global.upgrades["speed"])
    current_jump = base_jump * jump_multiplier * (1 + 0.15 * Global.upgrades["jump"])

func _physics_process(delta):
    var input_dir = Input.get_vector("left", "right", "forward", "backward")
    var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    velocity.x = direction.x * current_speed
    velocity.z = direction.z * current_speed
    
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = current_jump
    
    velocity.y -= 9.8 * delta
    move_and_slide()

func take_damage(amount):
    health -= amount
    if health <= 0:
        queueshka()

func queueshka():
    Global.reset_progress()
    get_tree().reload_current_scene()
