extends Node

# Разделение меша по материалам
var mesh = $VoxelModel.mesh
for i in mesh.get_surface_count():
    var material = mesh.surface_get_material(i)
    var new_mesh = ArrayMesh.new()
    new_mesh.add_surface_from_arrays(
        mesh.surface_get_primitive_type(i),
        mesh.surface_get_arrays(i)
    )
    var part = MeshInstance3D.new()
    part.mesh = new_mesh
    part.name = "Part_%d" % i
    add_child(part)
