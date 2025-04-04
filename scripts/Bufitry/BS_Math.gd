class_name BS_Math extends BS_Value

@export_enum("PLUS", "MINUS") var op: int = 0
@export var item_list: Array[BS_Value] = []

func GetResult() -> void:
	for item in item_list:
		
		var var_1: int = item.GetResult()
