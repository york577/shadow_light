extends Sprite2D


@export var player:CharacterBody2D
@export var light:Sprite2D


func _ready() -> void:
	pass # Replace with function body.


func _physics_process(_delta: float) -> void:
	var distance=player.global_position.x-global_position.x
	if distance>-50 and distance<100 and Input.is_action_just_pressed("Z"):
		light.move_light()
	
