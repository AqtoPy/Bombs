extends BaseBomb

func _ready():
    damage = 70
    blast_radius = 8.0

func explode():
    for i in 20:
        var shrapnel = Projectile.new()
        shrapnel.direction = Vector3(randf(), -1, randf())
        add_child(shrapnel)
    .explode()
