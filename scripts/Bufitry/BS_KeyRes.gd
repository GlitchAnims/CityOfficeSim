extends BufScript

var modKeyword_list: Array[StringName] = []
var isMultiplicative: bool = false
var mult: float = 1.0
var adder: int = 0

func ReceiveDamage_Before(buf: Buf, dmg_info: DmgInfo) -> void:
	var fits: bool = false
	for s in dmg_info.keyword_list:
		fits = modKeyword_list.has(s)
		if fits: break
	
	if fits:
		if isMultiplicative: dmg_info.mod_mult *= mult
		else: dmg_info.mod_mult += mult - 1.0
		dmg_info.mod_adder += adder
