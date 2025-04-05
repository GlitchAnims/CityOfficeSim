class_name BS_StackChange extends BufScript

@export var set_stack: bool = false
@export var default_stack: Vector2i = Vector2i.ZERO
@export var skip_getters: bool = true
@export var pot_getter: BS_Getter = null
@export var count_getter: BS_Getter = null

func Enact(buf: Buf) -> void:
	var stack: Vector2i = default_stack
	
	if not skip_getters:
		if is_instance_valid(pot_getter):
			
