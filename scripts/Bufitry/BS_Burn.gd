extends BufScript


func FullSecondTick(buf: Buf) -> void:
	var pot_float = float(buf.pot)
	var count_float = float(buf.count)
	
	var damage_mult: float = 1.0 + count_float * 0.03
	var damage: int = floori(pot_float * damage_mult)
	
	if is_instance_valid(buf.unit_ref):
		GameData.DamageHandlerNode.BufAttack(buf, buf.unit_ref, DmgInfo.new(damage, GameData.DMG_TYPE.NONE))
	
	
	var pot_loss: int = ceili(pot_float / 5)
	var count_loss: int = ceili(count_float / 3)
	buf.ChangeStack(Vector2i(-pot_loss, -count_loss))
