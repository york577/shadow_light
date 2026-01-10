extends CharacterBody2D

var state = Enum.State.YIN  # 随光变色，同步角色逻辑

const PUSH_SPEED = 300.0  # 推时速度

@export var sprite: Sprite2D

#func update_state(new_state: Enum.State):  # 光区Area调用
	#if state == new_state: return
	#state = new_state
	#modulate = Color(1.5,1.5,1.8) if state == Enum.State.YANG else Color(0,0,0)


@export var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = 0  # 无自移
	move_and_slide()
	
#func update_state(new_state: int):
	#if state == new_state: return
	#state = new_state as Enum.State
	#sprite.modulate = Color(1.5,1.5,1.8) if state == Enum.State.YANG else Color(0,0,0)

func try_push(direction: Vector2, pusher_state: int) -> bool:
	if state != pusher_state:  # 不同色推不动
		return false
	
	# 尝试推动方向移动
	velocity = direction * PUSH_SPEED
	move_and_slide()
	
	# 如果没移动（前方挡墙），停下
	if velocity.length() < 10:
		velocity = Vector2.ZERO
		return false
	
	velocity = Vector2.ZERO
	return true
