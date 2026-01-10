extends CanvasLayer


#全局场景列表
var gui_components=[
	"res://scene/ui/settings menus/settings_menu.tscn",
	"res://scene/ui/settings menus/esc_menu.tscn",
]

enum _SCREEN_SIZE{
	SCREEN_FULL,
	SCREEN_WINDOWX3,
	SCREEN_WINDOWX2,
}

var _screen_word={
	_SCREEN_SIZE.SCREEN_FULL:"全屏",
	_SCREEN_SIZE.SCREEN_WINDOWX3:"窗口X3",
	_SCREEN_SIZE.SCREEN_WINDOWX2:"窗口X2"
}

#分辨率尺寸
var resolutions= {
	_screen_word[_SCREEN_SIZE.SCREEN_FULL]:Window.MODE_FULLSCREEN,
	_screen_word[_SCREEN_SIZE.SCREEN_WINDOWX3]:Vector2i(1600,900),
	_screen_word[_SCREEN_SIZE.SCREEN_WINDOWX2]:Vector2i(1366,768),
}

#初始化加载场景
func _ready():
	for i in gui_components:
		var new_scene = load(i).instantiate()
		add_child(new_scene)
		new_scene.hide()
