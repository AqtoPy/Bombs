extends Node

@export var ground_mesh: MeshInstance3D
@export var crater_depth: float = 2.0
@export var decal_scene: PackedScene

var original_mesh: ArrayMesh

func _ready():
    # Преобразуем меш земли в ArrayMesh
    original_mesh = ArrayMesh.new()
    original_mesh.add_surface_from_arrays(
        Mesh.PRIMITIVE_TRIANGLES,
        ground_mesh.mesh.get_mesh_arrays()
    )
    ground_mesh.mesh = original_mesh

func create_crater(position: Vector3, radius: float):
    var mdt = MeshDataTool.new()
    mdt.create_from_surface(original_mesh, 0)
    
    for i in mdt.get_vertex_count():
        var vertex = mdt.get_vertex(i)
        var distance = position.distance_to(ground_mesh.global_transform * vertex)
        if distance < radius:
            var falloff = 1.0 - (distance / radius)
            vertex.y -= crater_depth * falloff
            mdt.set_vertex(i, vertex)
    
    original_mesh.clear_surfaces()
    mdt.commit_to_surface(original_mesh)
    ground_mesh.mesh = original_mesh
    
    # Добавляем декаль
    var decal = decal_scene.instantiate()
    decal.position = position
    decal.scale = Vector3(radius, 1, radius)
    add_child(decal)
