extends TileMap

@onready var hud = get_parent().get_parent().find_child("HUD").find_child("Control")
@onready var hud_tilemap = get_parent().get_parent().find_child("HUD").find_child("TileMap")

#tetrominoes
var i_0 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1)]
var i_90 := [Vector2i(2, 0), Vector2i(2, 1), Vector2i(2, 2), Vector2i(2, 3)]
var i_180 := [Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)]
var i_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)]
var i := [i_0, i_90, i_180, i_270]

var t_0 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var t_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var t_270 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var t := [t_0, t_90, t_180, t_270]

var o_0 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1)]
var o_90 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1)]
var o_180 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1)]
var o_270 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1)]
var o := [o_0, o_90, o_180, o_270]

var z_0 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1)]
var z_90 := [Vector2i(2, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
var z_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var z_270 := [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(0, 2)]
var z := [z_0, z_90, z_180, z_270]

var s_0 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1)]
var s_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var s_180 := [Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2), Vector2i(1, 2)]
var s_270 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 2)]
var s := [s_0, s_90, s_180, s_270]

var l_0 := [Vector2i(2, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var l_90 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(2, 2)]
var l_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(0, 2)]
var l_270 := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)]
var l := [l_0, l_90, l_180, l_270]

var j_0 := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1)]
var j_90 := [Vector2i(1, 0), Vector2i(2, 0), Vector2i(1, 1), Vector2i(1, 2)]
var j_180 := [Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(2, 2)]
var j_270 := [Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 2), Vector2i(1, 2)]
var j := [j_0, j_90, j_180, j_270]

var shapes := [i, t, o, z, s, l, j]
var shapes_full := shapes.duplicate()

#grid variables
const COLS : int = 10
const ROWS : int = 20
var weight : Array
signal weight_changed

#movement variables
const directions := [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN]
var keys : Array
var steps : Array
const steps_req : int = 50
const start_pos := Vector2i(4, 1)
var cur_pos : Vector2i
var speed : float
const ACCEL : float = 0.1#0.25
var first_step_value = 50
var step_value = 10
var rot_step_value = 0

#game piece variables
var piece_type
var next_piece_type
var rotation_index : int = 0
var active_piece : Array

#game variables
var score : int
const REWARD : int = 100
var game_running : bool

#tilemap variables
var tile_id : int = 0
var piece_atlas : Vector2i
var next_piece_atlas : Vector2i

#layer variables
var board_layer : int = 0
var active_layer : int = 1

func _ready():
	#new_game()
	hud.get_node("StartButton").pressed.connect(new_game)

func new_game():
	Global.play_sfx("newgame")
	#reset variables
	score = 0
	hud.get_node("ScoreLabel").text = "SCORE: " + str(score)
	speed = 1.0
	game_running = true
	keys = [0, 0, 0, 0] #0:left, 1:right, 2:down, 3:up
	steps = [0, 0, 0, 0] #0:left, 1:right, 2:down, 3:up
	hud.get_node("GameOverLabel").hide()
	#clear everything
	weight = [0, 0]
	weight_changed.emit(weight)
	get_parent().get_parent().current_rot = 0
	clear_piece()
	clear_board()
	clear_panel()
	piece_type = pick_piece()
	piece_atlas = Vector2i(shapes_full.find(piece_type), 0)
	next_piece_type = pick_piece()
	next_piece_atlas = Vector2i(shapes_full.find(next_piece_type), 0)
	create_piece()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if game_running:
		step_value = Global.sensitivity
		rot_step_value = Global.rot_sensitivity
		if Input.is_action_just_pressed("left"):
			keys[0] = true
			steps[0] = first_step_value
		elif Input.is_action_just_released("left"):
			keys[0] = false
			steps[0] = 0
		elif keys[0]:
			steps[0] += step_value
		
		if Input.is_action_just_pressed("right"):
			keys[1] = true
			steps[1] = first_step_value
		elif Input.is_action_just_released("right"):
			keys[1] = false
			steps[1] = 0
		elif keys[1]:
			steps[1] += step_value
		
		if Input.is_action_just_pressed("down"):
			keys[2] = true
			steps[2] = first_step_value
		elif Input.is_action_just_released("down"):
			keys[2] = false
			steps[2] = 0
		elif keys[2]:
			steps[2] += step_value
		
		if Input.is_action_just_pressed("up"):
			keys[3] = true
			steps[3] = first_step_value
		elif Input.is_action_just_released("up"):
			keys[3] = false
			steps[3] = 0
		elif keys[3]:
			steps[3] += rot_step_value / 2
		
		#apply downward movement every frame
		steps[2] += speed
		#move the piece
		for k in range(steps.size()):
			if steps[k] >= steps_req:
				if k == 3:
					rotate_piece()
				else:
					move_piece(directions[k])
				steps[k] = 0

func pick_piece():
	var piece
	if not shapes.is_empty():
		shapes.shuffle()
		piece = shapes.pop_front()
	else:
		shapes = shapes_full.duplicate()
		shapes.shuffle()
		piece = shapes.pop_front()
	return piece

func create_piece():
	#reset variables
	steps = [0, 0, 0, 0] #0:left, 1:right, 2:down
	cur_pos = start_pos
	active_piece = piece_type[rotation_index]
	draw_piece(active_piece, cur_pos, piece_atlas)
	#show next piece
	draw_piece_panel(next_piece_type[0], Vector2i(50, 9), next_piece_atlas)

func clear_piece():
	for k in active_piece:
		erase_cell(active_layer, cur_pos + k)

func draw_piece(piece, pos, atlas):
	for k in piece:
		set_cell(active_layer, pos + k, tile_id, atlas)

func draw_piece_panel(piece, pos, atlas):
	for k in piece:
		hud_tilemap.set_cell(active_layer, pos + k, tile_id, atlas)

func rotate_piece():
	if can_rotate():
		clear_piece()
		rotation_index = (rotation_index + 1) % 4
		active_piece = piece_type[rotation_index]
		draw_piece(active_piece, cur_pos, piece_atlas)
		Global.play_sfx("rotate")
	else:
		Global.play_sfx("negate")

func move_piece(dir):
	if can_move(dir):
		clear_piece()
		cur_pos += dir
		draw_piece(active_piece, cur_pos, piece_atlas)
		Global.play_sfx("move")
	else:
		if dir == Vector2i.DOWN:
			land_piece()
			check_rows()
			piece_type = next_piece_type
			piece_atlas = next_piece_atlas
			next_piece_type = pick_piece()
			next_piece_atlas = Vector2i(shapes_full.find(next_piece_type), 0)
			calc_weight()
			clear_panel()
			create_piece()
			check_game_over()
		else:
			Global.play_sfx("negate")

func can_move(dir):
	#check if there is space to move
	var cm = true
	for k in active_piece:
		if not is_free(k + cur_pos + dir):
			cm = false
	return cm

func can_rotate():
	var cr = true
	var temp_rotation_index = (rotation_index + 1) % 4
	for k in piece_type[temp_rotation_index]:
		if not is_free(k + cur_pos):
			cr = false
	return cr

func is_free(pos):
	return get_cell_source_id(board_layer, pos) == -1

func land_piece():
	Global.play_sfx("land")
	#remove each segment from the active layer and move to board layer
	for k in active_piece:
		erase_cell(active_layer, cur_pos + k)
		set_cell(board_layer, cur_pos + k, tile_id, piece_atlas)

func calc_weight():
	weight = [0, 0]
	var mult = COLS / 2 # COLS must be even
	var in_the_left = true
	for c in range(1, COLS+1):
		var count = 0
		for r in range(1, ROWS+1):
			if not is_free(Vector2i(c, r)):
				count += 1
		if in_the_left:
			weight[0] += mult * count
			mult -= 1
			if mult == 0:
				in_the_left = false
				mult = 1
		else:
			weight[1] += mult * count
			mult += 1
	weight_changed.emit(weight)

func clear_panel():
	for k in range(50, 54):
		for y in range(9, 11):
			hud_tilemap.erase_cell(active_layer, Vector2i(k, y))

func check_rows():
	var clears = 0
	var row : int = ROWS
	while row > 0:
		var count = 0
		for k in range(COLS):
			if not is_free(Vector2i(k + 1, row)):
				count += 1
		#if row is full then erase it
		if count == COLS:
			shift_rows(row)
			score += REWARD
			hud.get_node("ScoreLabel").text = "SCORE: " + str(score)
			speed += ACCEL
			clears += 1
		else:
			row -= 1
	if clears == 1:
		Global.play_sfx("one")
	elif clears == 2:
		Global.play_sfx("two")
	elif clears == 3:
		Global.play_sfx("three")
	elif clears >= 4:
		Global.play_sfx("tetris")

func shift_rows(row):
	var atlas
	for k in range(row, 1, -1):
		for y in range(COLS):
			atlas = get_cell_atlas_coords(board_layer, Vector2i(y + 1, k - 1))
			if atlas == Vector2i(-1, -1):
				erase_cell(board_layer, Vector2i(y + 1, k))
			else:
				set_cell(board_layer, Vector2i(y + 1, k), tile_id, atlas)

func clear_board():
	for k in range(ROWS):
		for y in range(COLS):
			erase_cell(board_layer, Vector2i(y + 1, k + 1))

func check_game_over():
	for k in active_piece:
		if not is_free(k + cur_pos):
			land_piece()
			game_over()

func game_over():
	Global.play_sfx("gameover")
	hud.get_node("GameOverLabel").show()
	game_running = false
	get_parent().get_parent().target_rot = get_parent().get_parent().current_rot
