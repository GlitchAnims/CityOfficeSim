class_name Buf extends Node

signal stack_changed
var pot_max: int = 99
var count_max: int = 99
var pot: int = 0
var count: int = 0

func ChangeStack(stack: Vector2i = Vector2i.ZERO) -> void:
	SetStack(Vector2i(maxi(pot + stack.x, 0), maxi(count + stack.y, 0)))

var value_list: Array[int] = [0,0,0,0,0,0,0,0,0,0]

## Set Potency or Count to -1 to prevent changing it
func SetStack(stack: Vector2i = Vector2i(-1,-1)) -> void:
	var pot_old: int = pot
	var count_old: int = count
	if not stack.x < 0: pot = mini(stack.x, pot_max)
	if not stack.y < 0: count = mini(stack.y, count_max)
	for script: BufScript in script_list:
		script.StackUpdate(self, pot_old, count_old)
	stack_changed.emit()

var unit_ref: Unit = null
var bufConfig_ref: BufConfig = null
var script_list: Array[BufScript] = []
var novelty: float = 1.0

func _process(delta: float) -> void:
	if novelty > 0: novelty = maxf(novelty - delta, 0)

func _ready() -> void:
	if not is_instance_valid(bufConfig_ref) or not is_instance_valid(unit_ref):
		queue_free()
		return
	for scriptGD: GDScript in bufConfig_ref.bufScript_list: script_list.push_back(scriptGD.new())
	for script: BufScript in script_list: script.WhenInit(self)
	GameData.FacilityNode.MakePopupText("+" + bufConfig_ref.bufName, unit_ref.position + Vector3(0,1.2,0), 4.0)

var halfsecond_timer: float = 0.5
var fullsecond: bool = false # Flips between true and false every halfsecond
func _physics_process(delta: float) -> void:
	var combatSpeed: float = GameData.combatSpeed_final
	var combatDelta: float = combatSpeed * delta
	
	halfsecond_timer -= combatDelta
	
	if halfsecond_timer <= 0:
		halfsecond_timer += 0.5 # Added .5 instead of set to .5 to remain consistent
		
		for script: BufScript in script_list:
			script.HalfSecondTick(self)
			if fullsecond: script.FullSecondTick(self)
		
		fullsecond = not fullsecond # Flip
