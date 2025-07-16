extends Node2D

var upgrade_type = 0
var hover : bool = false
var upgrade_gotten : bool = false
var active : bool = true

var type_title: Array = [
	"E Up",
	"D Down",
	"T Down",
	"Spawn-",
	"S Down",
	"S Up",
	"Score+"
]

var type_desc: Array = [
	"Energy Gain Up",
	"Enemy Energy Down",
	"Upgrades More Often",
	"Remove Spawners",
	"Decrease Spawner Time",
	"Instant Score +",
	"Score Grows Faster"
]

func _ready() -> void:
	random_upgrade()
	$Sprite2D/Title.text = type_title[upgrade_type]
	$Sprite2D/Upgrade.text = type_desc[upgrade_type]

func _physics_process(delta: float) -> void:
	if active:
		if hover:
			$Sprite2D.position.y = -4
		else:
			$Sprite2D.position.y = 0
		check_click()

func random_upgrade():
	upgrade_type = randi_range(0, 6)

func check_click():
	if hover:
		if Input.is_action_just_pressed("shoot") and !upgrade_gotten:
			get_upgrade()

func get_upgrade():
	upgrade_gotten = true
	active = false
	if upgrade_type == 0:
		PointController.gain_energy += 1
	if upgrade_type == 1:
		if PointController.escape_points < -1:
			PointController.escape_points += 1
	if upgrade_type == 2:
		PointController.next_threshold *= .8
	if upgrade_type == 3:
		SignalBus.remove_spawners.emit()
	if upgrade_type == 4:
		SignalBus.dec_spawn_time.emit()
	if upgrade_type == 5:
		PointController.points += 100
	if upgrade_type == 6:
		PointController.gain_points += 3
	SignalBus.upgrade_chosen.emit()

func fade_out():
	$AnimationPlayer.play("fade_out")

func _on_area_2d_mouse_entered() -> void:
	hover = true

func _on_area_2d_mouse_exited() -> void:
	hover = false
