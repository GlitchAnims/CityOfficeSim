class_name M_StackGetter extends M_Getter

@export_enum("Potency", "Count", "Old Potency", "Old Count") var pot_or_count: int = 0

func GetResult(mCore: ModularCore) -> float:
	if mCore.m_obj is not Buf: return default_result
	var buf: Buf = mCore.m_obj as Buf
	
	match pot_or_count:
		0: return buf.pot
		1: return buf.count
		2: return buf.pot_old
		3: return buf.count_old
	
	return default_result
