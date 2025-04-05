class_name M_Damage extends M_Consq

@export var dmg_method: DMG_METHOD
enum DMG_METHOD{
	NONE, OWNER
}

@export var target_getter: M_UnitGet
@export var dmg_default: int = 1
@export var dmg_getter: M_Getter
@export var lockout_default: int = 0
@export var lockout_getter: M_Getter
@export var dmg_type: GameData.DMG_TYPE = GameData.DMG_TYPE.NONE
@export var dmg_virtue: GameData.DMG_VIRTUE = GameData.DMG_VIRTUE.RED

func Enact(mCore: ModularCore) -> void:
	if not is_instance_valid(target_getter): return
	var target_list: Array[Unit] = target_getter.GetUnitList(mCore)
	var dmg: int = dmg_default
	if is_instance_valid(dmg_getter): dmg = int(dmg_getter.GetResult(mCore))
	var lockout: float = lockout_default
	if is_instance_valid(lockout_getter): lockout = lockout_getter.GetResult(mCore)
	
	match mCore.m_mode:
		ModularCore.M_MODE.BUF:
			var buf: Buf = mCore.m_obj
			
			if dmg_method == DMG_METHOD.OWNER:
				for target in target_list:
					var dmgInfo: DmgInfo = DmgInfo.new(dmg, dmg_type, dmg_virtue)
					dmgInfo.lockout = lockout
					dmgInfo.keyword_list.append(buf.bufConfig_ref.keyword_list)
					GameData.DamageHandlerNode.BufAttack(buf, target, dmgInfo)
