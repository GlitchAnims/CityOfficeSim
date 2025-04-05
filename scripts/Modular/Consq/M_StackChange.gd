class_name M_StackChange extends M_Consq

@export var set_stack: bool = false
@export var default_stack: Vector2i = Vector2i.ZERO
@export var skip_getters: bool = false
@export var pot_getter: M_Getter = null
@export var count_getter: M_Getter = null

func Enact(mCore: ModularCore) -> void:
	if mCore.m_obj is not Buf: return
	var buf: Buf = mCore.m_obj as Buf
	
	var stack: Vector2i = default_stack
	
	if not skip_getters:
		if is_instance_valid(pot_getter): stack.x = int(pot_getter.GetResult(mCore))
		if is_instance_valid(count_getter): stack.y = int(count_getter.GetResult(mCore))
	
	if set_stack: buf.SetStack(stack)
	else: buf.ChangeStack(stack)
