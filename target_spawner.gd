extends Node2D

@onready var target_plane = get_parent()
@onready var target_scene = load("res://bone_target.tscn")

@export var spawn_speed : int = randi_range(3,4)
var active : bool = false

func _ready() -> void:
	$SpawnTimer.wait_time = spawn_speed
	$SpawnTimer.start()
	self.visible = false

func spawn_target():
	if active == true:
		var new_target = target_scene.instantiate()
		new_target.type = "resetter"
		new_target.spawner_speed = spawn_speed
		new_target.parent = self
		new_target.global_position = $SpawnPoint.global_position #Vector2($BeginningMark.global_position.x, $BeginningMark.global_position.y)
		target_plane.add_child(new_target)
		active = false

func _on_spawn_timer_timeout() -> void:
	spawn_target()
