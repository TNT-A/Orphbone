extends Node2D

func _ready() -> void:
	SignalBus.upgrade_chosen.connect(destroy_self)
	$AnimationPlayer.play("fade_in")
	$upgrade_card.active = false
	$upgrade_card2.active = false
	await get_tree().create_timer(1).timeout
	$upgrade_card.active = true
	$upgrade_card2.active = true

func destroy_self():
	$upgrade_card.active = false
	$upgrade_card2.active = false
	$AnimationPlayer.play("fade_out")
	await get_tree().create_timer(.4).timeout
	SignalBus.game_continue.emit()
	queue_free()
