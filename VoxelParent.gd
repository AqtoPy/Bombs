extends Node3D

func _ready():
    var voxel_model = $VoxelModel  # Ваш MeshInstance3D с импортированной моделью
    var mesh = voxel_model.mesh
    
    # Проверяем, что меш существует
    if not mesh:
        push_error("VoxelModel не содержит меша!")
        return
    
    # Разделяем меш по материалам
    for i in mesh.get_surface_count():
        var material = mesh.surface_get_material(i)
        var arrays = mesh.surface_get_arrays(i)
        
        # Создаем новый меш для этой поверхности
        var new_mesh = ArrayMesh.new()
        new_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
        
        # Создаем MeshInstance3D для этой части
        var part = MeshInstance3D.new()
        part.mesh = new_mesh
        part.name = "Part_%d" % i
        
        # Применяем материал
        if material:
            part.material_override = material
        
        # Добавляем часть в сцену
        add_child(part)
        
        # Опционально: добавляем CollisionShape3D для физики
        var collision = CollisionShape3D.new()
        collision.shape = new_mesh.create_trimesh_shape()
        part.add_child(collision)
    
    # Удаляем оригинальную модель (опционально)
    voxel_model.queue_free()
