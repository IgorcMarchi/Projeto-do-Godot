extends Sprite2D
# Define que esse script é de um Sprite2D

var on_action: bool = false # Indica se uma animação especial está sendo executada
@export var animation: AnimationPlayer = null
# Permite escolher um AnimationPlayer no editor para controlar as animações
@export var mask_dude: CharacterBody2D = null
@export var dust_particles: GPUParticles2D = null

func animate(velocity: Vector2) -> void:
	change_orientation_based_on_direction(velocity.x)
	# Gira o sprite horizontalmente com base na direção do movimento
	
	if on_action: # Se uma animação especial estiver tocando, não faz nada (evita sobreposição)
		dust_particles.emitting = false
		return
	
	if velocity.y != 0: # Se o personagem estiver no ar (subindo ou caindo), toca animação de pulo ou queda
		dust_particles.emitting = false
		vertical_move_behavior(velocity.y)
		return
		
	horizontal_move_behavior(velocity.x)
	# Se estiver no chão, decide entre animação de "correr" ou "parado"
	
func change_orientation_based_on_direction(direction : float) -> void:
	if direction > 0:
		flip_h = false # Personagem virado para direita
	
	if direction < 0:
		flip_h = true # Personagem virado para esquerda
		
func action_behavior(action: String) -> void: 
	# Toca uma animação específica (como "double_jump") e impede que outras se sobreponham
	animation.play(action)
	on_action = true

func vertical_move_behavior(direction: float) -> void:
	if direction > 0: # Se estiver descendo, toca animação de queda
		animation.play("fall")
		
	if direction < 0: # Se estiver subindo, toca animação de pulo
		animation.play("jump")
	
func horizontal_move_behavior(direction: float) -> void:
	if direction != 0: 
		animation.play("run") #Se ele tiver se movendo a animação vai trocar para "run"(correndo)
		dust_particles.emitting = true
		return
		
	animation.play("idle") #Se não tiver se movendo a animação vai trocar para "Idle"(Parado)
	dust_particles.emitting = false
	
func on_animation_fineshed(anim_name: StringName) -> void:
	on_action = false
	# Quando a animação especial t ermina, libera para as outras animações voltarem a funcionar
	if anim_name == "hit":
		mask_dude.on_knockback = false
		
	if anim_name == "dead": # Quando personagem morrer vai reiniciar a cena
		hide()
		transition_screen.fade_in()
	
