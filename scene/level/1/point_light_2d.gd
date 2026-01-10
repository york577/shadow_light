extends Sprite2D


@export var caster:LightOccluder2D
@export var bridge:Area2D
var moving=false

var left=true
var origin_pz
func _ready() -> void:
	origin_pz=global_position

func move_light():
	var new_pz=Vector2(caster.global_position.x-2,global_position.y)
	if moving:
		return
	moving=true
	if not left:
		new_pz=origin_pz
	var tween=create_tween()
	tween.tween_property(self,"global_position",new_pz,0.5)
	await tween.finished
	left=!left
	bridge.build_bridge()
