extends Node2D

@onready var player: CharacterBody2D = get_node("MaskDude")
@onready var interface: CanvasLayer = get_node("interface")

@export var scene_path: String = ""

func _ready() -> void:
	interface.update_health(player.max_health)
	transition_screen.target_path = scene_path
	transition_screen.connect(
		"start_level", Callable(self, "start_level")
	)
	
	if transition_screen.current_score != 0: # verificar se o score é diferente de 0 se for recebe o score
		player.total_score = transition_screen.current_score #o player recebe o total do score
		interface.update_score(transition_screen.current_score) # A interface recebe o total do score
		
		
	if transition_screen.current_health != 0: # Se a vida for diferente de 0 quando fazer a transição
		player.health = transition_screen.current_health # a vida do player recebe a antiga vida
		interface.update_health(transition_screen.current_health) # interface recebe a antiga vida
		
func start_level() -> void:
	print("Aqui")
