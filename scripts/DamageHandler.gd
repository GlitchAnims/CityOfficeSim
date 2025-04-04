class_name DamageHandler extends Node

@onready var StrongholdNode: Stronghold = $".."

func SkillHit(skill: Skill, from: Unit, target: Unit, dmg_info: DmgInfo):
	
	for buf: Buf in from.BufListNode.get_children():
		for script: BufScript in buf.bufConfig_ref.bufScript_list:
			script.OnHit_Before(buf, target, dmg_info)
	
	for buf: Buf in target.BufListNode.get_children():
		for script: BufScript in buf.bufConfig_ref.bufScript_list:
			script.WhenHit_Before(buf, from, dmg_info)
	
	var dmg_final: int = 0
	
	for buf: Buf in from.BufListNode.get_children():
		for script: BufScript in buf.bufConfig_ref.bufScript_list:
			script.OnHit_After(buf, target, dmg_info, dmg_final)
	
	for buf: Buf in target.BufListNode.get_children():
		for script: BufScript in buf.bufConfig_ref.bufScript_list:
			script.WhenHit_After(buf, from, dmg_info, dmg_final)

func BufAttack(buf: Buf, target: Unit, dmg_info: DmgInfo) -> void:
	pass
