class_name BS_Math extends BS_Value

@export var op: MATH_OP = MATH_OP.ADD
@export var item_list: Array[BS_Value] = []

func GetResult(buf: Buf) -> int:
	var finalValue = default_result
	for i in item_list.size():
		if i == 0:
			finalValue = item_list[i].GetResult(buf)
			continue
		
		var newVar: int = item_list[i].GetResult(buf)
		
		match op:
			MATH_OP.ADD: finalValue += newVar
			MATH_OP.SUB: finalValue -= newVar
			MATH_OP.MUL: finalValue *= newVar
			MATH_OP.DIV: finalValue /= newVar
			MATH_OP.DIV_CEIL: finalValue = ceili(float(finalValue) / newVar)
			MATH_OP.DIV_FLOOR: finalValue = ceili(float(finalValue) / newVar)
			MATH_OP.MAX: finalValue = maxi(finalValue, newVar)
			MATH_OP.MIN: finalValue = mini(finalValue, newVar)
			MATH_OP.MOD: finalValue = finalValue % newVar
	
	return finalValue

enum MATH_OP{
	ADD, SUB, MUL, DIV, DIV_CEIL, DIV_FLOOR, MAX, MIN, MOD
}
