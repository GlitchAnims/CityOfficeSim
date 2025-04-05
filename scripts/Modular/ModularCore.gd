class_name ModularCore extends Object

var m_obj: Node = null

var m_self: Unit = null
var m_target: Unit = null
var m_dmgInfo: DmgInfo = null
var m_dmgFinal: int = 0

var m_mode: M_MODE
enum M_MODE{
	UNIT, SKILL, BUF, PASSIVE
}


var value_dict: Dictionary[int, int]
func ClearAllValues() -> void: value_dict.clear()
