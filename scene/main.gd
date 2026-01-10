extends CanvasLayer


@onready var seed_label=$ControlUI/Panel/StartMenu/Seed/MarginContainer
@onready var bgm:AudioStreamPlayer=$ControlUI/Main
@onready var start=$ControlUI/Start

@export var scroll_speed: float = 50.0  # 像素/秒，向左

var _time= Timer.new()
var is_playing=true
var language = "auto"

func _ready():
	_time.connect("timeout",Callable(self,"_start_time_out"))
	add_child(_time)

	if language == "auto":
		var preferred_language = OS.get_locale_language()
		TranslationServer.set_locale(preferred_language)
	else:
		TranslationServer.set_locale(language)

func _physics_process(_delta: float) -> void:
	pass
	#if !bgm.playing:
		#bgm.play()
	
func _on_start_pressed() ->void:
	_time.wait_time=0.4
	_time.start()
	start.play()
	
	
func _on_setting_pressed():
	var settings_menu=Common.find_node(PATH.KEY.SETTING)
	if is_instance_valid(settings_menu):
		settings_menu.visible=!settings_menu.visible


func _start_time_out():
	SceneManager.load_scene("res://scene/level/1.tscn")
	_time.stop()
	self.queue_free()


func _on_edit_pressed() -> void:
	seed_label.visible=!seed_label.visible


func _on_quit_pressed() -> void:
	get_tree().quit()
