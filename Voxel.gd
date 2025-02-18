extends RigidBody3D

@export var health: float = 10.0              # Здоровье вокселя
@export var destruction_effect: PackedScene   # Эффект разрушения
@export var auto_cleanup: bool = true         # Автоудаление через время
@export var cleanup_time: float = 10.0        # Время до автоудаления

func _ready():
    if auto_cleanup:
        $CleanupTimer.wait_time = cleanup_time
        $CleanupTimer.start()

# Применение силы от взрыва
func apply_explosion_force(force: Vector3):
    apply_central_impulse(force)
    take_damage(force.length() * 0.1)

# Получение урона
func take_damage(amount: float):
    health -= amount
    if health <= 0:
        destroy()

# Уничтожение вокселя
func destroy():
    if destruction_effect:
        var effect = destruction_effect.instantiate()
        get_parent().add_child(effect)
        effect.global_transform = global_transform
    queue_free()

# Автоудаление через время
func _on_cleanup_timer_timeout():
    queue_free()
