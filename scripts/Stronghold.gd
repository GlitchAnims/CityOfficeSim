class_name Stronghold extends Node

@onready var GamespaceNode: Gamespace = $"Gamespace"
@onready var DamageHandlerNode: DamageHandler = $"DamageHandler"

func _ready() -> void:
	GameData.StrongholdNode = self
	GameData.GamespaceNode = GamespaceNode
	GameData.DamageHandlerNode = DamageHandlerNode
	
	
	GameData.stronghold_readied.emit()
	#VerifySaveDir(SAVE_DIR)
