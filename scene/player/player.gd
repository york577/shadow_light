class_name WanJia
extends CharacterBody2D

#人物靠近可交互物品时，按下交互按键发送信号进入队列，然后场景中的可交互物品判断距离是否符合，如果符合则根据优先级依次消费信号

@export var detection_area: Area2D  # 角色移动时周围的可交互区域检测
var current_interactable = null

@export var right_ray_cast: RayCast2D  # 面向前方，长度30px
@export var left_ray_cast: RayCast2D  # 面向后方，长度30px
@export var up_ray_cast: RayCast2D  # 面向上方，长度30px
@onready var light_source: Node2D
@export var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite: Sprite2D = $Sprite2D

const SPEED = 400.0
const JUMP_VELOCITY = -400.0
var state = Enum.State.YIN  # 默认阴，随光变（用Area检测完全进入）

var nearby_interactables: Array[Interactable] = []
var held_item: Node2D = null
var direction: int = 1

func _ready():
	detection_area.area_entered.connect(_on_body_entered)
	detection_area.area_exited.connect(_on_body_exited)
	right_ray_cast.enabled = true

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Z"):  # E键
		var target = get_priority_target()
		if target and can_interact(target):
			interact_with(target)

func _process(_delta):
	if is_instance_valid(light_source):
		var new_state = get_light_state()
		if new_state != state:
			state = new_state as Enum.State
			update_visual()
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta * 1.2
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		velocity.y = JUMP_VELOCITY
	# 移动输入：长按持续移，松开停
	var input_dir = 0
	if Input.is_action_pressed("ui_right"):
		direction=1
		input_dir += 1
	if Input.is_action_pressed("ui_left"):
		input_dir -= 1
		direction=-1
		
	velocity.x = input_dir * SPEED
	if input_dir != 0:
		sprite.flip_h = input_dir < 0
	move_and_slide()
	
func get_priority_target() -> Node2D:
	if held_item:
		return held_item
	var ray_cast=right_ray_cast
	if direction==1:
		ray_cast=right_ray_cast
	elif direction==-1:
		ray_cast=left_ray_cast
	ray_cast.force_raycast_update()
	
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider is Interactable:
			return collider
		elif collider is RigidBody2D:
			return collider
	detection_area.get_overlapping_areas()
	if current_interactable:
		return current_interactable
	# 2. Fallback: 最近距离排序
	if nearby_interactables.is_empty():
		return null
	nearby_interactables.sort_custom(sort_by_distance)
	return nearby_interactables[0]

func _on_body_entered(body:Area2D):
	var parent=body.get_parent()
	if body is Area2D and parent and parent.name=="Switch" and body.has_method("interact"):
		current_interactable=body


func _on_body_exited(body:Area2D):
	current_interactable=null

func sort_by_distance(a: Interactable, b: Interactable) -> bool:
	return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)

#与物体交互
func interact_with(target: Node2D):
	if held_item:  # 举起物品时,扔出去
		target.change_status(true)
		held_item.throw(self)
		held_item = null
		return
	if target.has_method("pick_up"):
		target.change_status(false)
		target.pick_up(self)
		held_item = target
	elif target.has_method("interact"):# 开关:灯/门等
		target.interact(self)  

#是否可以交互，角色与物体状态是否相同
func can_interact(target: Node2D) -> bool:
	return target.state ==state

#根据光照射线,获取状态
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
	var status=Enum.State.YANG if float(light_count) / points.size() > 0.7 else Enum.State.YIN
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
		
		points = [Vector2(0,0), Vector2(0, -shape.height/2), Vector2(0, shape.height/2),Vector2(-shape.height/2,0),Vector2(shape.height/2,0)]
	# 加更多点或自定义
	return points

#更新角色状态
func update_visual():
	match state:
		Enum.State.YIN:
			sprite.texture=preload("res://assets/yin.png")
		Enum.State.YANG:
			sprite.texture=preload("res://assets/yang.png")
