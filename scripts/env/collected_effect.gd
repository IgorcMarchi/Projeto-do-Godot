extends AnimatedSprite2D

func _ready() -> void: # Quando iniciar
	is_playing()
	


func on_animation_fineshed() -> void: # quando animação terminar
	queue_free()
