class_name M_Math extends M_Getter

@export var op: MATH_OP = MATH_OP.ADD
@export var item_list: Array[M_Getter] = []

func GetResult(mCore: ModularCore) -> float:
	var finalValue: float = default_result
	for i in item_list.size():
		if i == 0:
			finalValue = item_list[i].GetResult(mCore)
			continue
		
		var newVar: float = item_list[i].GetResult(mCore)
		
		match op:
			MATH_OP.ADD: finalValue += newVar
			MATH_OP.SUB: finalValue -= newVar
			MATH_OP.MUL: finalValue *= newVar
			MATH_OP.MUL_CEIL: finalValue = ceilf(finalValue * newVar)
			MATH_OP.MUL_FLOOR: finalValue = floorf(finalValue * newVar)
			MATH_OP.DIV: finalValue /= int(newVar)
			MATH_OP.DIV_CEIL: finalValue = ceilf(finalValue / int(newVar))
			MATH_OP.DIV_FLOOR: finalValue = floorf(finalValue / int(newVar))
			MATH_OP.MAX: finalValue = maxf(finalValue, newVar)
			MATH_OP.MIN: finalValue = minf(finalValue, newVar)
			MATH_OP.MOD: finalValue = int(finalValue) % int(newVar)
	
	return finalValue

enum MATH_OP{
	ADD, SUB, MUL, MUL_CEIL, MUL_FLOOR, DIV, DIV_CEIL, DIV_FLOOR, MAX, MIN, MOD
}
