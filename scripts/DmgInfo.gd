class_name DmgInfo extends Object

func _init(set_dmg: int = 1,
set_dmg_type: GameData.DMG_TYPE = GameData.DMG_TYPE.NONE,
set_dmg_virtue: GameData.DMG_VIRTUE = GameData.DMG_VIRTUE.RED) -> void:
	dmg = set_dmg
	dmg_type = set_dmg_type
	dmg_virtue = set_dmg_virtue

var dmg: int = 0
var dmg_type: GameData.DMG_TYPE
var dmg_virtue: GameData.DMG_VIRTUE = GameData.DMG_VIRTUE.RED
var lockout: float = 0

var mod_mult: float = 1.0
var mod_adder: int = 0
