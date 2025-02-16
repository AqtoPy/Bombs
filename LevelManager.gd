extends Node

var current_level = 0
var levels = [
    {
        "duration": 120,
        "spawns": [
            {"type": "25mm", "interval": 3.0},
            {"type": "shrapnel", "interval": 5.0}
        ],
        "reward": 100
    },
    {
        "duration": 90,
        "spawns": [
            {"type": "152mm", "interval": 2.5},
            {"type": "FAB1500", "interval": 4.0}
        ],
        "reward": 250
    }
]

func start_next_level():
    current_level += 1
    var level_data = levels[current_level - 1]
    
    # Настройка спавна
    for spawn_info in level_data["spawns"]:
        var timer = Timer.new()
        timer.wait_time = spawn_info["interval"]
        timer.timeout.connect(
            $"../BombSpawner".spawn_bomb.bind(spawn_info["type"])
        add_child(timer)
        timer.start()
    
    # Запуск таймера уровня
    $LevelTimer.start(level_data["duration"])

func _on_level_timer_timeout():
    Global.add_coins(levels[current_level - 1]["reward"])
    show_level_complete()
