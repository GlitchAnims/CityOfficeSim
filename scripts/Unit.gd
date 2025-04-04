class_name Unit extends CharacterBody3D

const SPEED = 5.0

@export var bodyID: int = -1
@export var teamNum: int = -1
@export var displayName: String = ""

@export var ColShapeNode: CollisionShape3D
@onready var AttackZoneNode: Node3D = $"AttackNode"

## Set this every physics frame
var vel_relative: Vector3 = Vector3.ZERO
## Set this every physics frame
var angVel_relative: Vector3 = Vector3.ZERO

const Brain = preload("res://scripts/Brain.gd")
var brain: Brain = null
var brain_timer: float = 1.0

@export var hp_max: int = 100
@export var hp: int = 100
func SetupHP(value: int) -> void:
	hp_max = value
	hp = value
signal hp_changed

func ChangeHP(change: int) -> void:
	SetHP(maxi(hp + change, 0))
func SetHP(value: int) -> void:
	var hp_old: int = hp
	hp = mini(value, hp_max)
	hp_changed.emit()

signal lockoutstate_changed
var lockout_highest: float = 0.0
var lockout: float = 0.0
func TryAddLockout(value: float) -> void:
	if lockout < 0.02: return
	if value > lockout_highest:
		lockout += value - lockout_highest # Extends lockout by difference between old and new
		lockout_highest = value
		lockoutstate_changed.emit()
func TryReduceLockout(value: float) -> void:
	lockout = maxf(lockout - value, 0)
	if (is_zero_approx(lockout)):
		lockout_highest = 0
		lockoutstate_changed.emit()

signal isCorpse_changed
@export var isCorpse: bool = false:
	set(value):
		isCorpse = value
		isCorpse_changed.emit()
var fear: int = 0
var intimidation: int = 0

#Status Vars
var speedMult: float = 1.0
var turnSpeedMult: float = 1.0
var dmgGivenMult: float = 1.0
var dmgGivenAdder: int = 0
var dmgTakenMult: float = 1.0
var dmgTakenAdder: int = 0
var def_level: int = 0
var off_level: int = 0
var skillPowerMult: float = 1.0
var skillPowerAdder: int = 0
var skillPowerVarAdder: int = 0
var sloth: float = -1.0
var proficiencyMult: float = 1.0

func ResetStats() -> void:
	speedMult = 1.0
	turnSpeedMult = 1.0
	dmgGivenMult = 1.0
	dmgGivenAdder = 0
	dmgTakenMult = 1.0
	dmgTakenAdder = 0
	def_level = 0
	skillPowerMult = 1.0
	skillPowerAdder = 0
	skillPowerVarAdder = 0
	proficiencyMult = 1.0

var lastAttacker: Unit = null
var currentTarget: Unit = null:
	set(value):
		currentTarget = value
		target_changed.emit(self, value)
signal target_changed(value1: Unit, value2: Unit)

@export var revealed: bool = false
func RevealUnit() -> void:
	revealed = true
	revealed_changed.emit()
signal revealed_changed
var currentPurpose: PURPOSE = PURPOSE.idle:
	set(value):
		currentPurpose = value
		purpose_changed.emit()
signal purpose_changed
enum PURPOSE{
	idle, pursue,
}

var mouseNorm: Vector3 = Vector3.ONE
var aimNorm: Vector3 = Vector3.ONE
var position_util: Vector3 = Vector3.ZERO

var pushAccumulator: Vector3 = Vector3.ZERO

var wantsPhasing: bool = false
var isPhasing: bool = false

var translationCommand: Vector3 = Vector3.ZERO
var rotationCommand: Vector3 = Vector3.ZERO

func SnapCamToSelf() -> void:
	GameData.FacilityNode.CenterCamOnUnit(self)


#@export var config_name: StringName = &"Nil"
@export_range(0.0, 100.0) var moveSpeed: float = 10.0

@onready var SignageSpriteNode: Sprite3D = $"SignageSprite"
@onready var HealthbarViewportNode: SubViewport = $"HealthbarViewport"

@onready var SkillListNode: Node = $"SkillList"
signal skillInUse_changed
func FreeSkillInUse() -> void: skillInUse = null
var skillInUse: Skill = null:
	set(value):
		skillInUse = value
		skillInUse_changed.emit()

const buf_scene: PackedScene = preload("res://scenes/buf.tscn")
@onready var BufListNode: Node = $"BufList"
signal bufList_changed
func GiveBufFromConfig(bufConfig: BufConfig, duration: float = -1):
	for buf: Buf in BufListNode.get_children():
		if buf.bufConfig_ref != bufConfig: continue
		# buf exists, use given duration if more than 0, otherwise default duration
		buf.remaining = duration if duration > 0 else float(bufConfig.duration_default)
		return
	
	var newBuf: Buf = buf_scene.instantiate()
	newBuf.bufConfig_ref = bufConfig
	newBuf.unit_ref = self
	newBuf.remaining = duration if duration > 0 else float(bufConfig.duration_default)
	BufListNode.add_child(newBuf, true)
	bufList_changed.emit()

@export var AnimationPlayerNode: AnimationPlayer = null
@export var AnimationTreeNode: AnimationTree = null
@export var NavAgentNode: NavigationAgent3D

var fixed: bool = false

func _ready() -> void:
	brain_timer += ClientData.rng.randf()
	GameData.EnlistUnit(self)
	SignageSpriteNode.set_texture(HealthbarViewportNode.get_texture())
	_ready_unit()

func _ready_unit() -> void: pass

func _exit_tree() -> void:
	GameData.EnlistUnit(self, true)

func StatusCalcAndSet() -> void:
	ResetStats()
	#RunBufListCleanup()
	#for buf in bufList:
		#buf.bufScript.HalfSecondProcess(buf, self)
	#RunBufListCleanup()

var vel_exact: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if isCorpse: return
	if hp <= 0: # dead, do not fight
		ColShapeNode.disabled = true
		isCorpse = true
		#queue_free()
		return
	
	
	var combatSpeed: float = GameData.combatSpeed_final
	var in_event_self: bool = GameData.eventNodes.has(self)
	if in_event_self: combatSpeed = GameData.combatSpeed
	var combatDelta: float = combatSpeed * delta
	if GameData.in_event and not in_event_self: return
	#aimNorm = Vector3.from_angle(rotation)
	
	if not GameData.in_event: if lockout > 0: lockout -= combatDelta
	
	var blend: float = 1.0 - pow(0.5, combatDelta * 20.0)
	vel_exact = vel_exact.lerp(Vector3.ZERO, blend)
	
	
	if not translationCommand.is_zero_approx():
		position += translationCommand
		translationCommand = Vector3.ZERO
	
	# gravity
	var totalPushForce: Vector3 = Vector3(0,-3.0,0) * combatDelta
	
	if not fixed:
		if not pushAccumulator.is_zero_approx():
			totalPushForce += pushAccumulator
			pushAccumulator = Vector3.ZERO
		
		if not is_instance_valid(skillInUse):
			totalPushForce += _EnactMovement(totalPushForce, combatDelta)
	
	if not totalPushForce.is_zero_approx(): vel_exact += totalPushForce
	if fixed: vel_exact = Vector3.ZERO
	
	
	velocity = vel_exact * combatSpeed
	move_and_slide()
	
	_physics_process_unit(delta, combatDelta)

func _physics_process_unit(_delta: float, _combatDelta: float) -> void: pass

func _EnactMovement(totalPushForce: Vector3, combatDelta: float) -> Vector3:
	if not NavAgentNode.is_navigation_finished():
		var wantMoveTo: Vector3 = NavAgentNode.get_next_path_position()
		#if ClientData.rng.randf() < 0.05: print(NavAgentNode.get_target_position(), "  ", wantMoveTo)
		
		var moveSpeed_mod: float = moveSpeed * speedMult
		var moveSpeed_final: float = moveSpeed_mod * combatDelta
		
		var wantMoveVec: Vector3 = wantMoveTo - position
		var wantMoveNorm: Vector3 = wantMoveVec.normalized()
		totalPushForce += wantMoveNorm * moveSpeed_final
	
	return totalPushForce

func SetNewNavAgentDestination(pos: Vector3, _loud: bool = false) -> void:
	NavAgentNode.set_target_position(pos)

func UpdateSelectedVisual(_select: bool) -> void: pass

func _on_mouse_entered() -> void:
	GameData.FacilityNode.StartHoverUnit(self)
func _on_mouse_exited() -> void:
	GameData.FacilityNode.StopHoverUnit(self)

func IntoEvent(enter: bool = true) -> void:
	if enter:
		if not GameData.eventNodes.has(self):
			GameData.eventNodes.push_back(self)
		GameData.EventCheck()
	else:
		GameData.eventNodes.erase(self)

func TakeDamage(fromUnit: Unit, dmg: int, loud: bool = true) -> void:
	if dmg < 1: return
	hp -= dmg
	if loud: GameData.FacilityNode.MakePopupText("-" + str(dmg), position + Vector3(0,0.5,0))
	_AfterTakeDamage(fromUnit, dmg, loud)

func _AfterTakeDamage(_fromUnit: Unit, _dmg: int, _loud) -> void: pass

func _on_attack_zone_body_entered(body: Node3D) -> void:
	if not body is Unit: return
	var unit: Unit = body
	if unit.teamNum == teamNum: return
	if is_instance_valid(skillInUse):
		unit.TakeDamage(self, skillInUse.skillConfig_ref.damage_default)
		skillInUse._OnHitUnit(unit)
