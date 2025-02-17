extends Node

var current_level = 1
var coins = 0
var upgrades = {
    "speed": 1,
    "jump": 1,
    "health": 1
}

func add_coins(amount):
    coins += amount

func buy_upgrade(upgrade_type, cost):
    if coins >= cost:
        coins -= cost
        upgrades[upgrade_type] += 1
        return true
    return false

func reset_progress():
    # Сброс прогресса
    current_level = 1
    coins = 0
    upgrades = {
        "speed": 1,
        "jump": 1,
        "health": 1
    }
    print("Прогресс сброшен!")
