# SceneManager.gd - AutoLoad单例，用于管理场景切换
extends Node

# 加载场景的路径（预制场景）
@export var loading_scene_path: String = "res://scene/ui/loading_screen.tscn"

# 当前加载路径和场景
var current_target_path: String = ""
var current_loading_scene: Node = null

# 切换场景的函数
func load_scene(target_scene_path: String):
	if current_loading_scene != null:
		print("警告：已在加载中，无法重复启动")
		return

	current_target_path = target_scene_path
	
	# 启动异步加载
	if ResourceLoader.load_threaded_request(current_target_path) != OK:
		print("错误：启动加载失败 - " + current_target_path)
		current_target_path = ""
		return
	
	# 实例化加载场景并添加到场景树
	current_loading_scene = load(loading_scene_path).instantiate()
	get_tree().root.add_child(current_loading_scene)
	
	# 连接加载场景的信号
	current_loading_scene.progress_updated.connect(_on_progress_updated)
	current_loading_scene.loading_complete.connect(_on_loading_complete)
	
	# 开始轮询进度
	set_process(true)

# 进程函数，用于轮询加载进度
func _process(_delta):
	if current_target_path == "":
		return
	
	var progress_array: Array[float] = []
	var status = ResourceLoader.load_threaded_get_status(current_target_path, progress_array)
	
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			# 计算平均进度（处理多阶段）
			var total_progress: float = 0.0
			for p in progress_array:
				total_progress += p
			var avg_progress = (total_progress / progress_array.size()) * 100.0 if progress_array.size() > 0 else 0.0
			current_loading_scene.update_progress(avg_progress)
			# 添加调试打印
			#print("进度数组: ", progress_array, " | 平均: ", avg_progress)
		ResourceLoader.THREAD_LOAD_FAILED:
			print("错误：加载失败 - " + current_target_path)
			_complete_loading()
		ResourceLoader.THREAD_LOAD_LOADED:
			# 强制更新到100%
			current_loading_scene.update_progress(100.0)
			pass
		_:
			# 无效或其他状态，忽略
			print_debug("场景加载状态无效-------")

# 进度更新信号回调（可选，用于自定义逻辑）
func _on_progress_updated(_progress: float):
	# 可以在这里添加额外逻辑，如音效
	pass

# 加载完成信号回调
func _on_loading_complete():
	# 等待确保加载完成
	while ResourceLoader.load_threaded_get_status(current_target_path) != ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().process_frame
	
	# 获取加载的场景
	var loaded_scene = ResourceLoader.load_threaded_get(current_target_path) as PackedScene
	if loaded_scene == null:
		print("错误：无法获取加载的场景")
		_complete_loading()
		return
	
	# 切换到目标场景
	var error = get_tree().change_scene_to_packed(loaded_scene)
	if error != OK:
		print("错误：场景切换失败 - " + str(error))
	
	# 清理
	_complete_loading()

# 完成加载的内部函数（清理状态）
func _complete_loading():
	current_loading_scene.queue_free()
	current_loading_scene = null
	current_target_path = ""
	set_process(false)
