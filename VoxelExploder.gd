extends Node3D

@export var voxel_scene: PackedScene  # Сцена отдельного вокселя
@export var explosion_force: float = 50.0

func explode(origin: Vector3, radius: float):
    for child in get_children():
        if child is MeshInstance3D:
            # Создаем RigidBody3D для части
            var voxel_part = voxel_scene.instantiate()
            voxel_part.mesh = child.mesh
            voxel_part.global_transform = child.global_transform
            
            # Добавляем физику
            var collision = CollisionShape3D.new()
            collision.shape = child.mesh.create_trimesh_shape()
            voxel_part.add_child(collision)
            
            get_parent().add_child(voxel_part)
            
            # Применяем силу взрыва
            var direction = (voxel_part.global_position - origin).normalized()
            var distance = origin.distance_to(voxel_part.global_position)
            var force = (1.0 - (distance / radius)) * explosion_force
            voxel_part.apply_central_impulse(direction * force)
            
            child.queue_free()
