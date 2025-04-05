class_name M_DamageRes extends M_Consq

@export var affect_dmg: bool = true
@export var affect_lockout: bool = false
@export_enum("Multiplier", "Multiplier Base", "Flat Adder") var dmg_modify: int
@export var dmg_mult_def: float = 1.0
@export var lockout_mult_def: float = 1.0
@export var dmg_getter: M_Getter
@export var lockout_getter: M_Getter

@export var check_keywords: bool = false
@export var check_types: bool = false
@export var check_virtues: bool = false
@export var keywords_affected: Array[StringName] = []
@export var types_affected: Array[GameData.DMG_TYPE] = []
@export var virtues_affected: Array[GameData.DMG_VIRTUE] = []

func Enact(mCore: ModularCore) -> void:
	if not affect_dmg and not affect_lockout: return # Both should not be false
	
	var dmgInfo: DmgInfo = mCore.m_dmgInfo
	if check_types and not types_affected.has(dmgInfo.dmg_type): return
	if check_virtues and not virtues_affected.has(dmgInfo.dmg_virtue): return
	
	if check_keywords:
		var contains_keyword: bool = false
		for keyword in keywords_affected:
			if dmgInfo.keyword_list.has(keyword):
				contains_keyword = true
				break
		if not contains_keyword: return
	
	var dmg_mult: int = dmg_mult_def
	var lockout_mult: float = lockout_mult_def
	if affect_dmg:
		if is_instance_valid(dmg_getter): dmg_mult = dmg_getter.GetResult(mCore)
		if dmg_modify == 0: dmgInfo.mod_mult += dmg_mult
		elif dmg_modify == 1: dmgInfo.mod_mult_base += dmg_mult
		else: dmgInfo.mod_adder += int(dmg_mult)
	
	if affect_lockout:
		if is_instance_valid(lockout_getter): lockout_mult = lockout_getter.GetResult(mCore)
		dmgInfo.lockout *= lockout_mult
