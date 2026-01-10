extends Node

const LONG_PRESS_TIME_MSEC = 500  # 长按阈值（毫秒）
#
var press_start_time = 0

var long_press_triggered = false
var long_press_card_time=0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		# 检测按键按下瞬间并初始化时间
	if Input.is_action_just_pressed("Reload"):
		press_start_time = Time.get_ticks_msec()
		long_press_triggered = false
	# 持续检测按键按住状态
	if Input.is_action_pressed("Reload"):
		var current_time = Time.get_ticks_msec()
		# 达到阈值且未触发过时执行动作
		if not long_press_triggered and current_time - press_start_time >= LONG_PRESS_TIME_MSEC:
			_on_long_press()
			long_press_triggered = true  # 阻止重复触发
	else:
		# 按键释放后重置状态
		press_start_time = 0
		long_press_triggered = false

func _on_long_press():
	LevelMg.reset()
	SceneManager.load_scene("res://scene/level/1.tscn")

func _input(_event):
		
	#键盘监听
	if _event is InputEventKey:
		#键盘按键~触发 Esc菜单
		if Input.is_action_just_pressed("Esc"):
			var scene=get_tree().current_scene
			if !scene:
				return
			var current_scene_name = scene.name
			if current_scene_name=="Main":
				return
			var setting_menu = Common.find_node(PATH.KEY.SETTING)
			if setting_menu!=null&&setting_menu.visible:
				setting_menu.visible=!setting_menu.visible
			var _esc_menu = Common.find_node(PATH.KEY.ESC)
			if _esc_menu!=null:
				_esc_menu.visible=!_esc_menu.visible

var node_cache={}

func find_node(node_key) -> Node:
	if node_cache.has(node_key):
		var cached_node = node_cache[node_key]
		if is_instance_valid(cached_node):
			return cached_node
		else:
			node_cache.erase(node_key)  # 清理无效引用
			#push_warning("缓存节点已失效，已移除: %s" % node_key)
	var path: NodePath = PATH._node_path.get(node_key)
	if path.is_empty():
		push_error("find_node: 未知的 node_key: %s" % node_key)
		return null
	var node := get_tree().root.get_node(path)
	if node:
		node_cache[node_key] = node
		return node
	else:
		push_error("find_node: 路径未找到节点: %s (path: %s)" % [node_key, path])
		return null

func common_signal_emit0(signal1:Signal,nodeName,method_name):
	_check_common_signal_connect(signal1,find_node(nodeName),method_name)
	signal1.emit()

func common_signal_emit1(signal1:Signal,nodeName,method_name,param):
	_check_common_signal_connect(signal1,find_node(nodeName),method_name)
	signal1.emit(param)

func common_signal_emit2(signal1:Signal,nodeName,method_name,param1,param2):
	_check_common_signal_connect(signal1,find_node(nodeName),method_name)
	signal1.emit(param1,param2)

func _check_common_signal_connect(signal1:Signal,node,method_name):
	if signal1.get_connections().size()==0:
		#print_debug("信号连接成功 %s " % signal1.get_name())
		signal1.connect(Callable(node,method_name))
