class_name M_UnitGet extends Resource

@export var execString: String = "Self"

func GetUnitList(mCore: ModularCore) -> Array[Unit]:
	var result: Array[Unit] = []
	#var m_node: Node = mCore.m_obj
	
	match execString:
		"Self": result.push_back(mCore.m_self)
		"Target": result.push_back(mCore.m_target)
	
	
	
	return result
