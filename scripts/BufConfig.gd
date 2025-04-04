class_name BufConfig extends Resource

@export var bufName: String = "Nameless"
@export var icon: Texture2D = preload("res://icon.svg")
@export_range(1,600) var duration_default: int = 60

@export var bufScript_list: Array[BufScript] = []
@export var keyword_list: Array[StringName] = []
