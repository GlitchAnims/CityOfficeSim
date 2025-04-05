class_name BS_StackGetter extends BS_Getter

@export_enum("Potency", "Count") var mode: int = 0

func GetResult(buf: Buf) -> int:
	if mode == 0: return buf.pot
	else: return buf.count
