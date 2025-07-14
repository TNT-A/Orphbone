extends Node2D

var active : bool = false

@onready var projectile_plane = get_parent().find_child("projectile_plane")
@onready var orphbone_scene = preload("res://orphbone_projectile.tscn")

var energy = 10

func _ready() -> void:
	modulate.a = 0

func _physics_process(delta: float) -> void:
	energy = PointController.energy
	if Input.is_action_just_pressed("shoot"):
		spawn_orphbone()
	$Label.text = str(energy)

func spawn_orphbone():
	if active:
		PointController.add_energy(-1)
		var new_orphbone = orphbone_scene.instantiate()
		new_orphbone.global_position = Vector2(72, 82)
		new_orphbone.target = Vector2(get_global_mouse_position().x - 8, get_global_mouse_position().y - 8)
		projectile_plane.add_child(new_orphbone)

func fade_in():
	$AnimationPlayer.play("fade_in")
	active = true

func fade_out():
	$AnimationPlayer.play("fade_out")
	active = false
