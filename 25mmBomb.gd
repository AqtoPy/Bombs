extends BaseBomb

func _ready():
    mass = 20
    damage = 35
    blast_radius = 3.0
    $Mesh.material.albedo_color = Color.GRAY
