extends Node


var combatSpeed: float = 1.0
var combatSpeed_final: float = 1.0
var in_event: bool = false
var eventNodes: Array[Node] = []
func EventCheck() -> void:
	in_event = not eventNodes.is_empty()
	if in_event: combatSpeed_final = 0
	else: combatSpeed_final = combatSpeed


func _physics_process(_delta: float) -> void: EventCheck()

var cumulativeID_i: int = 20
func MakeBodyID() -> int:
	cumulativeID_i += 1
	return cumulativeID_i

var unitList: Array[Unit] = []
var unitDict: Dictionary

func EnlistUnit(unit: Unit, remove_instead: bool = false) -> void:
	if unit.bodyID == -1: unit.bodyID = MakeBodyID()
	if not remove_instead:
		if not unitList.has(unit): unitList.push_back(unit as Unit)
		unitDict.get_or_add(unit.bodyID, unit as Unit)
	else:
		unitList.erase(unit)
		unitDict.erase(unit.bodyID)


func _ready() -> void:
	guiray_query.collide_with_areas = true
	unit_rayquery.collide_with_areas = true
	m2ray_query.collide_with_areas = true

var guiray_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(Vector3.ONE, Vector3.ZERO, 0b001000)
var unit_rayquery: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(Vector3.ONE, Vector3.ZERO, 0b1000)
var m2ray_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(Vector3.ONE, Vector3.ZERO, 0b100000)
var floorRay_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(Vector3.ONE, Vector3.ZERO, 0b0010)


const loadloader_scene: PackedScene = preload("res://Scenes/load_loader.tscn")
func LoadNodeFromPath(parentNode: Node, path: String) -> Node:
	var loaderNode: LoadLoader = loadloader_scene.instantiate()
	loaderNode.scene_path = path
	parentNode.add_child(loaderNode)
	return loaderNode

signal stronghold_readied
func StrongholdIsReady() -> void: stronghold_readied.emit()

var unitConfigDict: Dictionary

var saveslot: String = "save_0"
