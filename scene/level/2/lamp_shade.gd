#extends Interactable
#
#@export var caster:StaticBody2D
#@export var bridge:Area2D
#var moving=false
#
#var left=true
#var origin_pz
#
#func _ready() -> void:
	#origin_pz=global_position
	#light.enabled = true  # 初始开
	#update_light_direction()
	#
#@onready var light: Light2D = $Light2D  # 子节点Light2D
#@export var direction: Vector2 = Vector2.RIGHT  # 光方向（单向锥）
#
#func toggle() -> void:
	#light.enabled = !light.enabled
#
#func update_light_direction() -> void:
	#light.rotation = direction.angle()  # 设置锥方向
#
#func interact(player: Node) -> void:
	#if is_movable:
		## 如果可推，类似箱子，但这里假设开关为主
		#pass
#
#
#func move_light():
	#var new_pz=Vector2(caster.global_position.x-2,global_position.y)
	#if moving:
		#return
	#moving=true
	#if not left:
		#new_pz=origin_pz
	#var tween=create_tween()
	#tween.tween_property(self,"global_position",new_pz,0.5)
	#await tween.finished
	#left=!left
	#moving=false
