extends ParallaxBackground

@onready var  parallax_layer:  ParallaxLayer = get_node("ParallaxLayer")
@onready var backgound_layer: TextureRect = get_node("ParallaxLayer/BackgroundLayer")

var background_images_list: Array = [ # Lista da cor de fundo do mapa
	"res://assests/Background/Blue.png", # 0
	"res://assests/Background/Brown.png", # 1
	"res://assests/Background/Gray.png", # 2
	"res://assests/Background/Green.png", # 3
	"res://assests/Background/Pink.png", # 4
	"res://assests/Background/Purple.png", # 5
	"res://assests/Background/Yellow.png", # 6
]

@export var direction: Vector2  # vetor de fireção
@export var move_speed: float #valor de velocidade

func _ready() -> void:
	backgound_layer.texture = load( # Vai carregar uma imagem dentro da list de background
		background_images_list[
			randi() % background_images_list.size() # Vai retornar um numero aleatório de 0 a 6
			]
	)
	
func _physics_process(delta: float) -> void:
	parallax_layer.motion_offset += direction * delta * move_speed #Mover ele
	
