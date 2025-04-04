extends BufScript


func FullSecondTick(buf: Buf) -> void:
	
	if is_instance_valid(buf.unit_ref):
		GameData.DamageHandlerNode.BufAttack(buf, buf.unit_ref)
	
	var pot_float = float(buf.pot)
	var pot_loss: int = ceili(pot_float / 5)
	
	var count_float = float(buf.count)
	var count_loss: int = ceili(count_float / 3)
	
	buf.ChangeStack(Vector2i(-pot_loss, -count_loss))
