extends MarginContainer


onready var health_bar: ProgressBar = $main_layout/top_bar/health_bar


func _ready() -> void:
	pass


func set_pc_health(hp):
	health_bar.value = hp
