extends CanvasLayer


func _on_button_pressed() -> void:
	var setting_menu:Node=get_tree().root.get_node("Gui/Settings Menu")
	self.visible=false
	setting_menu.visible=true

func _on_to_main_pressed() -> void:
	self.visible=false
	SceneManager.load_scene("res://scene/main.tscn")


func _on_restart_pressed() -> void:
	#SceneManager.load_scene("res://scene/board/board.tscn")
	self.visible=false


func _on_back_pressed() -> void:
	self.visible=false
