class_name DamageHandler extends Node

@onready var StrongholdNode: Stronghold = $".."

func SkillAttack(skill: Skill, from: Unit, target: Unit, dmg: int):
	pass

func BufAttack(buf: Buf, target: Unit, dmg: int) -> void:
	pass
