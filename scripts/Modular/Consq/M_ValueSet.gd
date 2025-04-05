class_name M_ValueSet extends M_Consq

@export_range(0, 999) var value_i: int = 0
@export var getter: M_Getter

func Enact(mCore: ModularCore) -> void:
	var value: int = -1
	if is_instance_valid(getter): value = int(getter.GetResult(mCore))
	mCore.value_dict.set(value_i, value)
