extends CanvasLayer

@export var effect_volume:HSlider
@export var bgm_volume:HSlider
@export var screen_label:Label
#背景音乐音量
@onready var bgm_bus= AudioServer.get_bus_index("Bgm")
#效果音量
@onready var game_bus= AudioServer.get_bus_index("Game")
var selected_key

#是否修改了分辨率
var is_change=false

func _ready():
	##TODO 从存档中读取设置初始数据
	call_deferred("update_label")

var current_index = 0

func update_label(index:int=1):
	current_index=index
	if selected_key!=Gui._screen_word[current_index]:
		is_change=true
	selected_key=Gui._screen_word[current_index]
	screen_label.text = selected_key
	
func _on_left_button_pressed():
	current_index = (current_index - 1 + Gui.resolutions.size()) % Gui.resolutions.size()
	update_label(current_index)

func _on_right_button_pressed():
	current_index = (current_index + 1) % Gui.resolutions.size()
	update_label(current_index)

@export var confirm_button:Button

func _on_save_pressed():
	#修改屏幕尺寸
	self.visible=!self.visible
	if is_change:
		var window_size =Gui.resolutions[selected_key]
		if is_instance_of(window_size,TYPE_INT):
			get_window().set_mode(Window.MODE_FULLSCREEN)
		else:
			get_window().set_mode(Window.MODE_WINDOWED)
			get_window().size=window_size
		get_window().move_to_center()
	else:
		is_change=false

func _on_confirm_button_up() -> void:
	# 松开时弹回并恢复
	create_tween().tween_property(confirm_button, "scale", Vector2(1, 1), 0.2)\
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	create_tween().tween_property(confirm_button, "modulate", Color.WHITE, 0.2)

func _on_exit_pressed():
	self.visible=!self.visible

func _on_bgm_hslider_value_changed(value: float) -> void:
	var bgm_value=linear_to_db(value)
	AudioServer.set_bus_volume_db(bgm_bus,bgm_value)


func _on_effect_hslider_value_changed(value: float) -> void:
	var effect_value=linear_to_db(value)
	AudioServer.set_bus_volume_db(game_bus,effect_value)

@export var screen_left_button:TextureButton
func _on_left_mouse_entered() -> void:
	var left_size=screen_left_button.get_rect().size
	screen_left_button.pivot_offset=Vector2(left_size.x/2,left_size.y/2)
	screen_left_button.scale=Vector2(1.3,1.3)
func _on_left_mouse_exited() -> void:
	screen_left_button.scale=Vector2(1.0,1.0)

@export var screen_right_button:TextureButton
func _on_right_mouse_entered() -> void:
	var left_size=screen_right_button.get_rect().size
	screen_right_button.pivot_offset=Vector2(left_size.x/2,left_size.y/2)
	screen_right_button.scale=Vector2(1.3,1.3)

func _on_right_mouse_exited() -> void:
	screen_right_button.scale=Vector2(1.0,1.0)

@export var language_left_button:TextureButton
func _on_left_lg_mouse_entered() -> void:
	var left_size=language_left_button.get_rect().size
	language_left_button.pivot_offset=Vector2(left_size.x/2,left_size.y/2)
	language_left_button.scale=Vector2(1.3,1.3)

func _on_left_lg_mouse_exited() -> void:
	language_left_button.scale=Vector2(1.0,1.0)

@export var language_right_button:TextureButton
func _on_right_lg_mouse_entered() -> void:
	var left_size=language_right_button.get_rect().size
	language_right_button.pivot_offset=Vector2(left_size.x/2,left_size.y/2)
	language_right_button.scale=Vector2(1.3,1.3)

func _on_right_lg_mouse_exited() -> void:
	language_right_button.scale=Vector2(1.0,1.0)
