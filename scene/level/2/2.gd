extends Node2D

func _ready() -> void:
	
	call_deferred("init_relation")

func init_relation():
	#灯光与角色
	var node=get_node("Interact/Object/1")
	if not is_instance_valid(node):
		return
	get_node("Player").light_source=node
	#开关与灯,钥匙与门
	var switchs= get_node("Interact/Switch")
	if switchs:
		for switch in switchs.get_children():
			if switch.has_signal("open"):
				switch.open.connect(_open)

func _open(obj_name):
	var obj_parent= get_node("Interact/Object")
	var switch_msg= str(obj_name).split("_")
	var number=switch_msg[0]
	var type=switch_msg[1]
	var obj= obj_parent.get_node(number)
	if not is_instance_valid(obj):
		push_warning("未找到对应的可操作物体")
		return
	if type=="move" and obj.has_method("move_light"):
		obj.move_light()
		
func _process(_delta: float) -> void:
	pass
