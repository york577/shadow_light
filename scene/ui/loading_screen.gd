# LoadingScreen.gd - 加载场景的脚本
extends CanvasLayer

# 信号：进度更新
signal progress_updated(progress: float)

# 信号：加载完成
signal loading_complete

# UI节点引用（在编辑器中拖拽赋值，或用get_node）
@onready var progress_bar: ProgressBar = $Panel/ProgressBar
@onready var label: RichTextLabel = $Panel/Label

# 是否正在完成（避免重复触发）
var _is_completing: bool = false

# 更新进度函数
func update_progress(percentage: float):
	progress_bar.value = percentage
	label.text = "加载中... %d%%" % int(percentage)
	progress_updated.emit(percentage)
	
	# 当进度达到100%时，非阻塞延迟后发出完成信号
	if percentage >= 100.0 and not _is_completing:
		_is_completing = true
		get_tree().create_timer(0.5).timeout.connect(func(): loading_complete.emit())
