class_name WanJia
extends CharacterBody2D

var state = Enum.State.YIN  # 默认阴，随光变（用Area检测完全进入）

@onready var light_source: Node2D = get_parent().get_node("LampShade")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite: Sprite2D = $Sprite2D

func _process(_delta):
	var new_state = get_light_state()
	if new_state != state:
		state = new_state as Enum.State
		update_visual()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
	
	# 移动输入：长按持续移，松开停
	var input_dir = 0
	if Input.is_action_pressed("ui_right"):
		input_dir += 1
	if Input.is_action_pressed("ui_left"):
		input_dir -= 1
	
	velocity.x = input_dir * SPEED
	if input_dir != 0:
		sprite.flip_h = input_dir < 0

	move_and_slide()
	
# 推箱：遍历本帧碰撞，用remainder推
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is CharacterBody2D and "state" in collider:  # 是箱子
			#print("检测到推箱碰撞")  # 调试：长按时每帧输出
			
			if collider.state == state:  # 同色
				var remainder = collision.get_remainder()
				if remainder.length() > 0:
					collider.position += remainder # 精确推剩余距离
					#print("长按持续推！")
			else:
				velocity.x = 0  # 不同色挡住
				#print("不同色挡住")
	
	# 松开减速
	if input_dir == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED * 2)


func update_state(new_state: Enum.State):  # 光区Area调用
	if state == new_state: return
	state = new_state
	modulate = Color(1.5,1.5,1.8) if state == Enum.State.YANG else Color(0,0,0)
	
func get_light_state() -> int:
	var points = get_sample_points()  # 同之前，多点采样角色范围
	var light_count = 0
	
	for point in points:
		var global_point = to_global(point)
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(light_source.global_position, global_point)
		query.exclude = [self]  # 排除自身
		query.collide_with_bodies = true  # 击中StaticBody2D (Occluder实体)
		query.collide_with_areas = false
		
		var result = space_state.intersect_ray(query)
		
		if not result or result.collider.is_in_group("occluder_ignore"):  # 没击中Occluder实体 → 在光
			light_count += 1
	
	# “完全进入”规则：80%+点在光 → 阳，否则阴（可调阈值）
	var status=Enum.State.YANG if float(light_count) / points.size() > 0.99 else Enum.State.YIN
	
	return status

func get_sample_points() -> Array[Vector2]:
	var points:Array[Vector2] = []
	var shape = $CollisionShape2D.shape
	if shape is RectangleShape2D:
		var ext = shape.size / 2
		points = [
			Vector2(0,0),  # 中心
			Vector2(-ext.x, -ext.y), Vector2(ext.x, -ext.y),
			Vector2(-ext.x, ext.y), Vector2(ext.x, ext.y)
		]
	elif shape is CapsuleShape2D:
		var rect:Rect2=shape.get_rect()
		points = [Vector2(0,0), Vector2(0, -shape.height/2), Vector2(0, shape.height/2),Vector2(-shape.height/2,0),Vector2(shape.height/2,0)]
	# 加更多点或自定义
	return points

func update_visual():
	match state:
		Enum.State.YIN:
			sprite.texture=preload("res://assets/yin.png")
		Enum.State.YANG:
			sprite.texture=preload("res://assets/yang.png")
