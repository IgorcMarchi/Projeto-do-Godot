extends StaticBody2D
@onready var state_timer: Timer = get_node("StateTimer") # declarando a variavel
@onready var animation: AnimationPlayer = get_node("Animation") #declarando a variavel

var max_health: int = 0
var current_state: String = "off"
var is_invicible: bool = false

@export var damage: int  # Variavel para dano
@export var health: int = 15

func _ready() -> void:
	max_health = health

func on_state_timer_timeout() -> void: #O estado muda de acordo com o valor, ele vai virar o inverso do atual
	state_timer.start()
	
	if current_state == "off":
		current_state = "on"
		is_invicible = true
		animation.play(current_state)
		
		return
	if current_state == "on":
		current_state = "off"
		is_invicible = false
		animation.play(current_state)
		return


func on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("mask_dude"):
		body.update_health(global_position, damage, "decrease")
		

func update_health(value: int) -> void:
	print("dano 5")
	if is_invicible:
		return
	health = clamp(health - value, 0, max_health)
	if health == 0:
		state_timer.stop()
		is_invicible = true
		current_state = "off"
		animation.play(current_state)
		
		return
		
	animation.play("hit")


func on_animation_fineshed(anim_name: StringName) -> void:
	if anim_name == "hit":
		animation.play(current_state)
