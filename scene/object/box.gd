extends RigidBody2D

var state=Enum.State.YIN

signal pushed_by_player(pos: Vector2)
signal picked_up(player: Node)
signal thrown()

var is_held: bool = false
@export var area: Area2D # 子节点检测玩家碰撞

func _physics_process(_delta: float) -> void:
	if freeze:
		return
	
	# 推逻辑：玩家相邻 + 按推键
	var overlapping = area.get_overlapping_bodies()
	for body in overlapping:
		if body.name == "Player":
			var direction=0
			if Input.is_action_pressed("Left") and body.global_position.x>global_position.x:
				direction=-1
			elif Input.is_action_pressed("Right") and body.global_position.x<global_position.x:
				direction=1
			if color_matches(body.state):
				global_position=Vector2(global_position.x+6*direction,global_position.y)
			return

func pick_up(player: Node) -> void:
	if color_matches(player.state):
	#	picked_up.emit(player)
		reparent(player)  # 附玩家，成为子节点跟随移动
		position = Vector2(0, -50)  # 举过头顶偏移
		#linear_velocity = Vector2.ZERO  # 停速

func throw(player: Node) -> void:
	thrown.emit()
	reparent(get_tree().current_scene)  # 回主场景
	global_position += Vector2(20 * player.direction, -10)  # 扔前方微调
	linear_velocity = Vector2(400 * player.direction, -100)  # 弧线扔力


func change_status(active:bool):
	if active:
		freeze = false
		gravity_scale=1
		collision_layer=1
		collision_mask=1
	else:
		freeze = true
		gravity_scale = 0
		collision_layer = 0
		collision_mask = 0
		linear_velocity = Vector2.ZERO
		
		
func color_matches(player_state: Enum.State) -> bool:
	return state == player_state
