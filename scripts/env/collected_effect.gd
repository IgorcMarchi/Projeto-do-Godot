extends AnimatedSprite2D

func _ready() -> void:
	is_playing()
	


func on_animation_fineshed() -> void:
	queue_free()
