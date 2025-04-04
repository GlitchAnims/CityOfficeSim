class_name BufConfig extends Resource

@export var bufName: String = "Nameless"
@export var icon: Texture2D = preload("res://icon.svg")
@export_range(1,600) var duration_default: int = 60

@export var bufScript_list: Array[BufScript] = []
@export var keyword_list: Array[StringName] = []

func EnactBufScripts(buf: Buf, timing: BufScript.TIMING = BufScript.TIMING.FULL_SECOND_TICK) -> void:
	for bufScript in bufScript_list:
		if bufScript.timing == timing: bufScript.Enact(buf)

func WhenInit(buf: Buf) -> void: EnactBufScripts(buf, BufScript.TIMING.WHEN_INIT)
func WhenDestroyed(buf: Buf) -> void: EnactBufScripts(buf, BufScript.TIMING.WHEN_DESTROYED)

func HalfSecondTick(buf: Buf) -> void: EnactBufScripts(buf, BufScript.TIMING.HALF_SECOND_TICK)
func FullSecondTick(buf: Buf) -> void: EnactBufScripts(buf)
func StackUpdate(buf: Buf) -> void: EnactBufScripts(buf, BufScript.TIMING.STACK_UPDATE)

func OnHit_Before(buf: Buf, target: Unit, dmg_info: DmgInfo) -> void:
	buf.bufTarget = target
	buf.bufDmgInfo = dmg_info
	EnactBufScripts(buf, BufScript.TIMING.ON_HIT_BEFORE)
func OnHit_After(buf: Buf, target: Unit, dmg_info: DmgInfo, dmg_final: int) -> void: 
	buf.bufTarget = target
	buf.bufDmgInfo = dmg_info
	buf.bufDmgFinal = dmg_final
	EnactBufScripts(buf, BufScript.TIMING.ON_HIT_AFTER)

func WhenHit_Before(buf: Buf, from: Unit, dmg_info: DmgInfo) -> void: 
	buf.bufTarget = from
	buf.bufDmgInfo = dmg_info
	EnactBufScripts(buf, BufScript.TIMING.WHEN_HIT_BEFORE)
func WhenHit_After(buf: Buf, from: Unit, dmg_info: DmgInfo, dmg_final: int) -> void: 
	buf.bufTarget = from
	buf.bufDmgInfo = dmg_info
	buf.bufDmgFinal = dmg_final
	EnactBufScripts(buf, BufScript.TIMING.WHEN_HIT_AFTER)

func ReceiveDamage_Before(buf: Buf, dmg_info: DmgInfo) -> void: 
	buf.bufTarget = null
	buf.bufDmgInfo = dmg_info
	EnactBufScripts(buf, BufScript.TIMING.RECEIVE_DAMAGE_BEFORE)
func ReceiveDamage_After(buf: Buf, dmg_info: DmgInfo, dmg_final: int) -> void: 
	buf.bufTarget = null
	buf.bufDmgInfo = dmg_info
	buf.bufDmgFinal = dmg_final
	EnactBufScripts(buf, BufScript.TIMING.RECEIVE_DAMAGE_AFTER)
