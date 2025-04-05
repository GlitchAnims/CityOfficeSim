class_name M_ValueGet extends M_Math

@export_range(0, 999) var value_i: int = 0

func GetResult(mCore: ModularCore) -> float:
	return mCore.value_dict.get(value_i, default_result)
