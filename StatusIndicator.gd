extends Label

@export var status_type: String = "speed"

func _process(_delta):
    var player = get_node("/root/Main/Player")
    var value = ""
    
    match status_type:
        "speed":
            value = "%.1f m/s" % player.current_speed
        "jump":
            value = "%.1f m" % player.current_jump
    
    text = "%s: %s" % [status_type.capitalize(), value]
    
    if player.debuff_level > 0:
        add_theme_color_override("font_color", Color.RED)
    else:
        add_theme_color_override("font_color", Color.WHITE)
