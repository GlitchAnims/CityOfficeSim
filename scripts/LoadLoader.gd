extends Node

@onready var ParentNode = $".."
var scene_path: String = ""
var percentage_progress: float = 0.0

func _ready() -> void:
	if scene_path.is_empty():
		queue_free()
		return
	
	ResourceLoader.load_threaded_request(scene_path)

func _process(delta: float) -> void:
	var progress: Array = []
	ResourceLoader.load_threaded_get_status(scene_path, progress)
	percentage_progress = float(progress[0])
	if percentage_progress >= 1:
		Load(ResourceLoader.load_threaded_get(scene_path) as PackedScene)

func Load(packed_scene: PackedScene) -> void:
	var newNode: Node = packed_scene.instantiate()
	ParentNode.add_child(newNode, true)
	queue_free()
	#get_tree().change_scene_to_packed(packed_scene)
