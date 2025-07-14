extends Node2D

var next_check : int = 100

func _ready() -> void:
	modulate.a = 0

func _physics_process(delta: float) -> void:
	$Sprite2D/Label.text = str(PointController.points)
	check_score()

func check_score():
	if PointController.points >= next_check:
		$AnimationPlayer.play("fade in")
		next_check += 100

func flash():
	$AnimationPlayer.play("flash")
