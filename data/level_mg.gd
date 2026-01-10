extends Node

var current_level=1

var not_exist=false

func reset():
	not_exist=false
	current_level=1

func next_level():
	if not_exist:
		return
	var script_path="res://scene/level/"+str(current_level+1)+"/"+str(current_level+1)+".tscn"
	if not FileAccess.file_exists(script_path)&&!ResourceLoader.exists(script_path):
		push_warning("脚本文件不存在: " + script_path)
		not_exist=true
		return
	current_level+=1
	SceneManager.load_scene(script_path)
	not_exist=false
