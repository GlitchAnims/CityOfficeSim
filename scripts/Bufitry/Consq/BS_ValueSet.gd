class_name BS_ValueSet extends BS_Consq

@export var getter: BS_Getter = null
@export_range(0,9) var value_idx: int = 0

func Enact(buf: Buf) -> void:
	if is_instance_valid(getter):
		getter.GetResult(buf)
