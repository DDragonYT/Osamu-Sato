class_name GameController extends Node

@export var world_3d: Node3D
@export var default_scene: String
var current_gui_scene: Node3D

func _ready():
	set_scene(default_scene)

func start_switch(collider):
	var player_pos = collider.position
	var player_rot = collider.rotation
	var new_scene = collider.destination
	set_scene(new_scene, player_pos, player_rot)
	
func set_scene(scene_dir, player_pos = false, player_rot = false):
	var new = load(scene_dir).instantiate()
	var player = new.get_node("Player")
	player.game_controller = self
	if player_pos:
		player.position = player_pos
	if player_rot:
		player_rot = player.rotation
	if current_gui_scene:
		world_3d.remove_child(current_gui_scene)
	world_3d.add_child(new)
	current_gui_scene = new
