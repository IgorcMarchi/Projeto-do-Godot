extends Area2D

@onready var sprite: Sprite2D = get_node("Texture")
var fruit_list: Array = [ # Lista de frutas
	"res://assests/Items/Fruits/Apple.png",
	"res://assests/Items/Fruits/Bananas.png",
	"res://assests/Items/Fruits/Cherries.png",
	"res://assests/Items/Fruits/Kiwi.png",
	"res://assests/Items/Fruits/Melon.png",
	"res://assests/Items/Fruits/Orange.png",
	"res://assests/Items/Fruits/Pineapple.png",
	"res://assests/Items/Fruits/Strawberry.png",
]
var scores_list: Array = [ # Lista de pontuação
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8
]
var score: int = 0
@export var collected_effect: PackedScene = null

func _ready() -> void:
	randomize()
	
	var random_number: int = randi() % fruit_list.size() #Um numero aleatório
	sprite.texture = load(
		fruit_list[random_number] # Frutas aleatórias da lista
	)
	score = scores_list[random_number] # Score vai receber a lista de pontuação


func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mask_dude"): # verificando o grupo
		body.update_score(score)
		body.update_health(Vector2.ZERO, randi() % 3 + 1, "increase")
		spawn_effect() # spawna o efeito
		queue_free() # para deletar o objeto ja coletado

func spawn_effect() -> void:
	var effect = collected_effect.instantiate() #instancia
	effect.global_position = global_position # o efeito vai ser na posição da fruta
	get_tree().root.call_deferred("add_child", effect)
	
