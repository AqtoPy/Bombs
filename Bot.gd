extends CharacterBody3D

var target_position: Vector3
var health = 100
var is_panicking = false

func _physics_process(delta):
    if is_panicking:
        flee_from_danger()
    else:
        wander()

func flee_from_danger():
    var dir = (global_position - $DangerDetector.get_overlapping_bodies()[0].global_position).normalized()
    velocity = dir * 5.0
    move_and_slide()

func take_damage(amount):
    health -= amount
    if health <= 0:
        queue_free()
