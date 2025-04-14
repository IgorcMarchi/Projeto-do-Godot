extends CharacterBody2D


@onready var sprite : Sprite2D = get_node("Texture")
# Obtém o nó filho chamado "Texture" (Sprite2D) assim que a cena for carregada
@onready var stomp_area_collision: CollisionShape2D = get_node("StompArea/Colision")

var total_score: int = 0

var jump_count: int = 0 # Conta quantos pulos foram dados 
var is_on_double_jump: bool = false # Marca se o personagem já executou o pulo duplo

var is_dead: bool = false
var on_knockback: bool = false # saber se o knockback esta ativado ou não
var knockback_direction: Vector2 # direção que knockback vai fazer o personagem receber

@export var health: float = 25.0
@export var max_health: float = 0.0
@export var move_speed: float = 64.0 # Velocidade horizontal
@export var jump_speed: float = -256.0 # Força do pulo
@export var gravity_speed: float = 512.0 #Força da gravidade

@export var damage: int = 5

func _ready() -> void:
	max_health = health
	
	
func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	if on_knockback:
		knockback_move()
		return
		
	move() # Chama a função que lida com o movimento horizontal
	velocity.y += delta * gravity_speed # Aplica gravidade constantemente, simulando queda
	var _move := move_and_slide() # Aplica o movimento e lida com colisões
	jump() # Checa se o personagem pode pular ou fazer pulo duplo
	
	sprite.animate(velocity) # Atualiza a animação com base no movimento atual
	
func knockback_move() -> void:
	velocity = knockback_direction * move_speed * 2
	var _move := move_and_slide()
	sprite.animate(velocity)
	
func move() ->  void:
	var direction: float = get_direction()
	# Recebe a direção
	velocity.x = direction * move_speed
	# Aplica a direção multiplicada pela velocidade horizontal(x)

func get_direction() -> float:
	return(
		Input.get_axis("walk_left", "walk_right")
		#Pega as teclas onde "A" vai para esquerda vale -1 e "D" vai para direita vale 1
	)

func jump() -> void:
	if is_on_floor(): # Se o personagem estiver no chão:
		jump_count = 0  #Zera a contagem de pulo
		is_on_double_jump = false # Permite novo pulo duplo
		stomp_area_collision.set_deferred("disabled", true)

		
	if Input.is_action_just_pressed("jump") and jump_count < 2: # Se a tecla de pulo for pressionada e ainda não pulou 2x
		stomp_area_collision.set_deferred("disabled", false)
		velocity.y = jump_speed # Aplica a força do pulo
		jump_count += 1 # Aumenta a contagem de pulo
		
	if jump_count == 2 and not  is_on_double_jump: # Se está fazendo o segundo pulo (pulo duplo):
		sprite.action_behavior("double_jump") # Toca a animação específica do pulo duplo
		is_on_double_jump = true # Marca que o pulo duplo já foi usado
		

func update_health(target_position: Vector2, value: int, type: String) -> void: #Mostrar que perdeu vida
	if is_dead == true: # Já morreu
		return
	if type == "decrease":
		knockback_direction = (global_position - target_position).normalized()
		sprite.action_behavior("hit") # Ação na animação hit
		on_knockback = true # knockback ativado
		# 25 HP - 5 = 20, 0, 25
		health = clamp(health - value, 0, max_health) # tira vida
		transition_screen.current_health = health
		get_tree().call_group("interface", "update_health", health)
		
		if health == 0: # Se tiver igual a 0 então morreu
			is_dead = true # você morreu
			transition_screen.reset()
			sprite.action_behavior("dead") # Ação na animação hit
		return
	if type == "increase":
		health = clamp(health + value, 0, max_health) # Aumenta vida
		transition_screen.current_health = health
		get_tree().call_group("interface", "update_health", health)
		
	
func on_stomp_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("hazard") and body.is_invicible == false:
		body.update_health(damage)
		knockback_direction = (global_position - body.global_position).normalized()
		sprite.action_behavior("hit") # Ação na animação hit
		on_knockback = true # knockback ativado
		
func update_score(score: int) -> void:
	total_score += score
	transition_screen.current_score = total_score
	get_tree().call_group("interface", "update_score", total_score)
