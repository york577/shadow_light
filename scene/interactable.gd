class_name Interactable
extends Area2D
#所有可交互物继承

enum ColorType {BLACK, WHITE}

@export var color: ColorType = ColorType.BLACK  # 固定颜色
@export var is_movable: bool = false  # 是否可推/拾取

# 虚拟函数，子类重写
func interact(_player: Node) -> void:
	pass  # 如拾取、按下等
