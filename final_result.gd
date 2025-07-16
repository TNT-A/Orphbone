extends Node2D

func _ready() -> void:
	$Sprite2D.visible = false

func _physics_process(delta: float) -> void:
	$Sprite2D/ScoreDisplay.text = str(PointController.points)
	$Sprite2D/HighScore2.text = str(PointController.high_score)

func fade_in():
	$Sprite2D.visible = true
	$AnimationPlayer.play("fade_in")

func _on_button_pressed() -> void:
	SignalBus.reset_game.emit()
