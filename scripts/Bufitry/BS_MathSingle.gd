class_name BS_MathSingle extends BS_Getter

@export var item: BS_Getter = null

func GetResult(buf: Buf) -> int:
	var finalValue = default_result
	if is_instance_valid(item): finalValue = item.GetResult(buf)
	
	match op:
		SINGLE_OP.ABS: finalValue = abs(finalValue)
		SINGLE_OP.NEG: finalValue *= -1
	
	return finalValue

@export var op: SINGLE_OP = SINGLE_OP.ABS
enum SINGLE_OP{
	ABS, NEG
}
