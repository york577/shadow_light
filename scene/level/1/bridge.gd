extends Area2D
#
#@export var light_source: PointLight2D
#@export var occluder: PhysicsBody2D
#@onready var bridge_collision: CollisionPolygon2D = get_parent().get_node("ShadowBridge")
#@onready var ray_count: int = 30  # 射线数量，可调
#@export var coverage_threshold: float = 0.95  # 95%覆盖才生成桥

@onready var bridge_tscn=preload("res://scene/level/1/1_bridge.tscn")
var bridge_built: bool = false
#
#func _process(_delta: float) -> void:
	#if bridge_built:
		#return
	#
	#var pit_rect: Rect2 = get_node("CollisionShape2D").shape.get_rect()
	##pit_rect = pit_area.to_global(pit_rect)  # 全局坐标
	#
	#var covered_rays: int = 0
	#
	## 在坑区均匀发射射线（从光源向下/向坑中心）
	#for i in ray_count:
		#var t: float = (i + 0.5) / ray_count  # 0到1均匀分布
		#var target_pos: Vector2 = pit_rect.position.lerp(pit_rect.end, t)
		#
		#var space_state = get_world_2d().direct_space_state
		#var query = PhysicsRayQueryParameters2D.create(light_source.global_position, target_pos)
		#query.exclude = [self]  # 排除自身
		#query.collide_with_areas = false
		#query.collide_with_bodies = true
		#
		#var result = space_state.intersect_ray(query)
		#
		## 如果射线击中occluder，说明这点在影子里（被挡住）
		#if result and result.collider == occluder:
			#covered_rays += 1
	#
	#var coverage: float = float(covered_rays) / ray_count
	#
	#if coverage >= coverage_threshold:
		#build_bridge()
		#print("桥生成！影子完美覆盖")
		
func build_bridge() -> void:
	if bridge_built:
		return
	bridge_built = true
	## 用坑的形状直接生成桥碰撞（简单矩形桥）
	#var pit_shape = get_node("CollisionShape2D").shape as RectangleShape2D
	#var pit_poly = [
		#Vector2(-pit_shape.size.x/2, -pit_shape.size.y/2),
		#Vector2(pit_shape.size.x/2, -pit_shape.size.y/2),
		#Vector2(pit_shape.size.x/2, pit_shape.size.y/2),
		#Vector2(-pit_shape.size.x/2, pit_shape.size.y/2)
	#]
	#bridge_collision.polygon = pit_poly
	#bridge_collision.global_position = global_position
	#bridge_collision.disabled = false
	
	# 可选：加粒子/音效/动画
	# var particles = preload("res://BridgeParticles.tscn").instantiate()
	# add_child(particles)
	var bridge=bridge_tscn.instantiate()
	add_child(bridge)
