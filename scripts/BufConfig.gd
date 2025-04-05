class_name BufConfig extends Resource

@export var bufName: String = "Nameless"
@export var icon: Texture2D = preload("res://icon.svg")

@export var has_count: bool = false
@export var consq_list: Array[M_Consq] = []
@export var keyword_list: Array[StringName] = []

func EnactBufScripts(buf: Buf, timing: M_Consq.TIMING = M_Consq.TIMING.FULL_SECOND_TICK) -> void:
	var mCore: ModularCore = buf.mCore_ref
	for consq in consq_list:
		if consq.timing == timing: consq.Enact(mCore)

func WhenInit(buf: Buf) -> void: EnactBufScripts(buf, M_Consq.TIMING.WHEN_INIT)
func WhenDestroyed(buf: Buf) -> void: EnactBufScripts(buf, M_Consq.TIMING.WHEN_DESTROYED)

func HalfSecondTick(buf: Buf) -> void: EnactBufScripts(buf, M_Consq.TIMING.HALF_SECOND_TICK)
func FullSecondTick(buf: Buf) -> void: EnactBufScripts(buf)
func StackUpdate(buf: Buf) -> void: EnactBufScripts(buf, M_Consq.TIMING.STACK_UPDATE)

func OnHit_Before(buf: Buf, target: Unit, dmg_info: DmgInfo) -> void:
	buf.bufTarget = target
	buf.bufDmgInfo = dmg_info
	EnactBufScripts(buf, M_Consq.TIMING.ON_HIT_BEFORE)
func OnHit_After(buf: Buf, target: Unit, dmg_info: DmgInfo, dmg_final: int) -> void: 
	buf.bufTarget = target
	buf.bufDmgInfo = dmg_info
	buf.bufDmgFinal = dmg_final
	EnactBufScripts(buf, M_Consq.TIMING.ON_HIT_AFTER)

func WhenHit_Before(buf: Buf, from: Unit, dmg_info: DmgInfo) -> void: 
	buf.bufTarget = from
	buf.bufDmgInfo = dmg_info
	EnactBufScripts(buf, M_Consq.TIMING.WHEN_HIT_BEFORE)
func WhenHit_After(buf: Buf, from: Unit, dmg_info: DmgInfo, dmg_final: int) -> void: 
	buf.bufTarget = from
	buf.bufDmgInfo = dmg_info
	buf.bufDmgFinal = dmg_final
	EnactBufScripts(buf, M_Consq.TIMING.WHEN_HIT_AFTER)

func ReceiveDamage_Before(buf: Buf, dmg_info: DmgInfo) -> void: 
	buf.bufTarget = null
	buf.bufDmgInfo = dmg_info
	EnactBufScripts(buf, M_Consq.TIMING.RECEIVE_DAMAGE_BEFORE)
func ReceiveDamage_After(buf: Buf, dmg_info: DmgInfo, dmg_final: int) -> void: 
	buf.bufTarget = null
	buf.bufDmgInfo = dmg_info
	buf.bufDmgFinal = dmg_final
	EnactBufScripts(buf, M_Consq.TIMING.RECEIVE_DAMAGE_AFTER)
