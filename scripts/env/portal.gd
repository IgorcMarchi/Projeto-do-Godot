extends Area2D

@export var scene_path: String = ""

func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mask_dude"): # grupo do personage,
		transition_screen.target_path = scene_path # ele lê o caminho que esta em scene path
		body.set_physics_process(false)
		body.sprite.action_behavior("dead")
