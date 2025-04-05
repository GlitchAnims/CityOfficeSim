class_name M_MathSingle extends M_Getter

@export var op: SINGLE_OP = SINGLE_OP.ABS
@export var getter: M_Getter = null
@export var applicable: float = 0

func GetResult(mCore: ModularCore) -> float:
	var finalValue = default_result
	if is_instance_valid(getter): finalValue = getter.GetResult(mCore)
	
	match op:
		SINGLE_OP.ADD: finalValue += applicable
		SINGLE_OP.SUB: finalValue -= applicable
		SINGLE_OP.MUL: finalValue *= applicable
		SINGLE_OP.MUL_CEIL: finalValue = ceilf(finalValue * applicable)
		SINGLE_OP.MUL_FLOOR: finalValue = floorf(finalValue * applicable)
		SINGLE_OP.DIV: finalValue /= int(applicable)
		SINGLE_OP.DIV_CEIL: finalValue = ceilf(finalValue / int(applicable))
		SINGLE_OP.DIV_FLOOR: finalValue = floorf(finalValue / int(applicable))
		SINGLE_OP.MAX: finalValue = maxf(finalValue, applicable)
		SINGLE_OP.MIN: finalValue = minf(finalValue, applicable)
		SINGLE_OP.MOD: finalValue = int(finalValue) % int(applicable)
		SINGLE_OP.ABS: finalValue = abs(finalValue)
		SINGLE_OP.NEG: finalValue *= -1
		SINGLE_OP.CEIL: finalValue = ceilf(finalValue)
		SINGLE_OP.FLOOR: finalValue = floorf(finalValue)
	
	return finalValue


enum SINGLE_OP{
	ADD, SUB, MUL, MUL_CEIL, MUL_FLOOR, DIV, DIV_CEIL, DIV_FLOOR, MAX, MIN, MOD,
	ABS, NEG, CEIL, FLOOR
}
