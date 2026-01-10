extends Area2D

@export var player:CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(player):
		return
	var distance=player.global_position.x-global_position.x
	if distance>0:
		LevelMg.next_level()
