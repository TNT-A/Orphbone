class_name target
extends Node2D

@onready var stationary_spawner = preload("res://target_spawner.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#types: resetter, stationary, moving, teleport
@export var type : String 
@export var health = 3
@export var is_alive : bool = true
@export var tp_speed : int = 3
@export var is_teleporting : bool = false
var is_escaping : bool = false
var is_dying : bool = false
var unhittable : bool = true

var spr_block = preload("res://sprites/square_orpheus.png")
var spr_mouth = preload("res://sprites/big_mounth_orph.png")
var spr_board = preload("res://sprites/orphboard.png")
var spr_balloon = preload("res://sprites/balloon_orph.png")

func _ready() -> void:
	is_alive = true
	$AnimationPlayer.play("spawn")
	$SpawnTimer.wait_time = tp_speed
	$SpawnTimer.start()
	if type == "stationary":
		$CharacterBody2D/Sprite2D.texture = spr_block
	if type == "moving":
		$CharacterBody2D/Sprite2D.texture = spr_balloon
	if type == "teleport":
		$CharacterBody2D/Sprite2D.texture = spr_board
	if type == "resetter":
		$CharacterBody2D/Sprite2D.texture = spr_mouth
	await get_tree().create_timer(.3).timeout
	unhittable = false

func _physics_process(delta: float) -> void:
	if !is_alive:
		queue_free()
	if type == "moving":
		slide(delta)

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("hits_targets"):
		hit()
	if area.is_in_group("kill_zone"):
		escape()

func hit():
	if health >= 1 and !is_escaping and !is_dying and !unhittable:
		health -= 1
		self.animation_player.play("flash")
		if health <= 0:
			if type == "resetter":
				create_spawner()
			add_energy()
			#animation_player.play("flash")
			#await get_tree().create_timer(.4).timeout
			animation_player.play("die")
			is_dying = true
			await get_tree().create_timer(.6).timeout
			is_alive = false
		if (type == "stationary" or type == "resetter") and should_crumble:
			await get_tree().create_timer(.4).timeout
			$AnimationPlayer.play("crumble")
			$CrumbleTimer.start()

func escape():
	animation_player.stop()
	is_escaping = true
	PointController.add_energy(PointController.escape_points)
	if type == "resetter":
		create_spawner()
	animation_player.play("die")
	await get_tree().create_timer(.6).timeout
	queue_free()

func add_energy():
	PointController.add_energy(5)
	PointController.add_points(10)

var parent
var spawner_speed
func create_spawner():
	parent.active = true

var speed
var direction
func slide(delta):
	$CharacterBody2D.velocity = direction*speed*delta
	$CharacterBody2D.move_and_slide()

func teleport():
	$AnimationPlayer.play("teleport_out")
	await get_tree().create_timer(.8).timeout
	global_position = Vector2(randi_range(15, 145), randi_range(10, 80))
	$AnimationPlayer.play("teleport_in")
	is_teleporting = false

var should_crumble
func _on_spawn_timer_timeout() -> void:
	if type == "teleport":
		teleport()
	if type == "stationary" or type == "resetter" :
		should_crumble = true
		$AnimationPlayer.play("crumble")
		$CrumbleTimer.start()
		$SpawnTimer.stop()

func _on_crumble_timer_timeout() -> void:
	escape()
