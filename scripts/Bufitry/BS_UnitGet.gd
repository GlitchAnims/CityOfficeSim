class_name BS_UnitGet extends Resource

var execString: String = "Self"

func GetUnitList(buf: Buf) -> Array[Unit]:
	var result: Array[Unit] = []
	
	match(execString):
		"Self": result.push_back(buf.unit_ref)
		"Target": result.push_back(buf.bufTarget)
	
	return result
