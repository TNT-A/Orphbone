extends Label

func _ready() -> void:
	$AnimationPlayer.play("flash")
	pass

func fade_out():
	$AnimationPlayer.play("fade_out")
