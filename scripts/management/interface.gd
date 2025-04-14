extends CanvasLayer

@onready var score: Label = get_node("Score")
@onready var health: Label = get_node("Health")

func _ready() -> void: # quando inicar o valor do score é igual a 0
	score.text = 'Score: 0'
	
	
func update_health(value: int) -> void: # função para printar o valor da vida
	health.text = str(value) + " Health"
	
	
func update_score(new_score: int) -> void: # função para printar o valor do score
	score.text = 'Score: ' + str(new_score)
