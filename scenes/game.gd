extends Node2D

var current_rot = 0
var target_rot = 0
var steps = 0.20

func _process(_delta):
	if current_rot > target_rot:
		current_rot -= steps
		if current_rot < target_rot:
			current_rot = target_rot
	if current_rot < target_rot:
		current_rot += steps
		if current_rot > target_rot:
			current_rot = target_rot
	
	$Node2D.set_rotation_degrees(current_rot/2)
	if abs(current_rot) > 45:
		if current_rot < 0:
			target_rot = -45
			current_rot = -45
		else:
			target_rot = 45
			current_rot = 45
		$Node2D/TileMap.game_over()

func _on_tile_map_weight_changed(weight):
	target_rot = weight[1] - weight[0]
	if abs(target_rot) > 30:
		Global.play_warning(true)
	else:
		Global.play_warning(false)
