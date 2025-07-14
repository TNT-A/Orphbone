extends Node2D

var main_scene = preload("res://gallery.tscn")

var game_started : bool = false
var game_over : bool = false

var deactivated_spawners : Array = []
var activated_spawners : Array = []

func _ready() -> void:
	$Logo.fade_in()
	$BoneShooter.fade_out()
	PointController.energy = 10
	PointController.points = 0
	game_started = false
	game_over = false
	sort_spawners()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("shoot") and !game_started and !game_over:
		game_started = true
		$Logo.fade_out()
		$BoneShooter.fade_in()
		start_game()
	if Input.is_action_just_pressed("shoot") and game_over:
		await get_tree().create_timer(.2).timeout
		get_tree().change_scene_to_packed(main_scene)
		print("I'm reloading")
	check_win()

func check_win():
	if PointController.energy <= 0 and !game_over:
		lose_game()

func lose_game():
	stop_game()
	game_started = false
	game_over = true
	$BoneShooter.fade_out()
	$Scorebox.flash()

func stop_game():
	for item in activated_spawners:
		item.active = false
	$AddTimer.stop()
	$RemoveTimer.stop()
	$ShakeUpTimer.stop()
	activated_spawners.clear()
	deactivated_spawners.clear()
	for child in $target_plane.get_children():
		if child.is_in_group("target"):
			child.queue_free()

func start_game():
	PointController.energy = 10
	PointController.points = 0
	$AddTimer.start()
	$RemoveTimer.start()
	$ShakeUpTimer.start()
	add_spawner()
	add_spawner()
	add_spawner()

func sort_spawners():
	for child in $target_plane.get_children():
		deactivated_spawners.append(child)
		child.active = false

func add_spawner():
	var deactivated_spawners_length = len(deactivated_spawners) - 1
	if deactivated_spawners_length <= 0:
		deactivated_spawners_length = 0
	var rand_spawner = randi_range(0, deactivated_spawners_length)
	var new_spawner = deactivated_spawners[rand_spawner]
	if len(deactivated_spawners) > 0:
		activated_spawners.append(new_spawner)
		deactivated_spawners.remove_at(rand_spawner)
		new_spawner.active = true

func remove_spawner():
	var activated_spawners_length = len(activated_spawners) - 1
	if activated_spawners_length <= 0:
		activated_spawners_length = 0
	var rand_spawner = randi_range(0, activated_spawners_length)
	var removed_spawner = activated_spawners[rand_spawner]
	if len(activated_spawners) > 0:
		deactivated_spawners.append(removed_spawner)
		activated_spawners.remove_at(rand_spawner)
		removed_spawner.active = false

func shake_up():
	var num_shakeup = len(activated_spawners)/2
	for i in num_shakeup:
		add_spawner()
		remove_spawner()

func _on_add_timer_timeout() -> void:
	add_spawner()

func _on_remove_timer_timeout() -> void:
	remove_spawner()

func _on_shake_up_timer_timeout() -> void:
	shake_up()
