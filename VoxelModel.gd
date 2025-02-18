extends Node3D

@export var voxel_scene: PackedScene  # Сцена отдельного вокселя
@export var explosion_force: float = 10.0

func explode(origin: Vector3, radius: float):
    for child in get_children():
        if child is MeshInstance3D:
            # Создаем отдельный воксель
            var voxel = voxel_scene.instantiate()
            voxel.global_transform = child.global_transform
            get_parent().add_child(voxel)
            
            # Применяем силу взрыва
            var direction = (voxel.global_position - origin).normalized()
            var distance = origin.distance_to(voxel.global_position)
            var force = (1.0 - (distance / radius)) * explosion_force
            
            if voxel.has_method("apply_force"):
                voxel.apply_force(direction * force)
            
            # Удаляем оригинальный воксель
            child.queue_free()
