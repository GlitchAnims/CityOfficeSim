class_name Skill extends Node

@export var visible: bool = true:
	set(value):
		visible = value
		visible_changed.emit(value)
signal visible_changed(value: bool)

@export var displayName: String = "nameless skill"
@export var unitOwner_ref: Unit = null
@export var skillConfig_ref: SkillConfig = null
@export var override_lookDir: bool = false
@export var npc_distance: float = 1.0

func _ready() -> void:
	if not is_instance_valid(skillConfig_ref) or not is_instance_valid(unitOwner_ref):
		queue_free()
		return

var cooldown: float = 0.0:
	set(value):
		cooldown = maxf(value, 0)
		cooldown_changed.emit()
signal cooldown_changed()

func _physics_process(delta: float) -> void:
	var combatDelta = delta * GameData.combatSpeed_final
	
	if not is_zero_approx(cooldown):
		cooldown -= combatDelta

func UseThis() -> void:
	if GameData.in_event:
		GameData.FacilityNode.MakePopupText("Currently in Event", unitOwner_ref.position + Vector3(0,1,0))
		return
	if not is_zero_approx(cooldown) or unitOwner_ref.lockout > 0:
		GameData.FacilityNode.MakePopupText("Under cooldown", unitOwner_ref.position + Vector3(0,1,0))
		return
	_SkillActivation()

## Override this for effects
func _DoEffect(num: int = 0) -> void:
	pass

## Override this
func _OnHitUnit(unit: Unit) -> void: pass
func _ManageLookDir() -> void: pass
func _SkillEnd() -> void:
	unitOwner_ref.FreeSkillInUse()
func _SkillActivation() -> void: pass
