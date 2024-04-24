extends Node2D

@onready var sfx_stream = $SFX
@onready var clear_stream = $Clear_SFX
@onready var warning_stream = $Warning_SFX

var sensitivity = 10
var rot_sensitivity = 0

#SFXs
var move_sfx = preload("res://assets/SFX/03 - SE_GAME_MOVE.wav")
var rot_sfx = preload("res://assets/SFX/04 - SE_GAME_ROTATE.wav")
var land_sfx = preload("res://assets/SFX/07 - SE_GAME_LANDING.wav")
var pause_sfx = preload("res://assets/SFX/08 - SE_GAME_HOLD.wav")
var one_sfx = preload("res://assets/SFX/09 - SE_GAME_SINGLE.wav")
var two_sfx = preload("res://assets/SFX/10 - SE_GAME_DOUBLE.wav")
var three_sfx = preload("res://assets/SFX/11 - SE_GAME_TRIPLE.wav")
var tetris_sfx = preload("res://assets/SFX/12 - SE_GAME_TETRIS.wav")
var negate_sfx = preload("res://assets/SFX/15 - SE_GAME_FIXA.wav")
var newgame_sfx = preload("res://assets/SFX/17 - ME_GAME_REMAIN_1.wav")
var gameover_sfx = preload("res://assets/SFX/19 - SE_GAME_KO2.wav")
#var warning_sfx = preload("res://assets/SFX/心電図1.mp3")

func _ready():
	$BGMusic.play()

func _process(_delta):
	pass

func play_sfx(id):
	if sfx_stream.is_playing():
		sfx_stream.stop()
	if id == "move":
		sfx_stream.set_stream(move_sfx)
		sfx_stream.play()
	elif id == "rotate":
		sfx_stream.set_stream(rot_sfx)
		sfx_stream.play()
	elif id == "land":
		sfx_stream.set_stream(land_sfx)
		sfx_stream.play()
	elif id == "pause":
		sfx_stream.set_stream(pause_sfx)
		sfx_stream.play()
	elif id == "one":
		clear_stream.set_stream(one_sfx)
		clear_stream.play()
	elif id == "two":
		clear_stream.set_stream(two_sfx)
		clear_stream.play()
	elif id == "three":
		clear_stream.set_stream(three_sfx)
		clear_stream.play()
	elif id == "tetris":
		clear_stream.set_stream(tetris_sfx)
		clear_stream.play()
	elif id == "negate":
		sfx_stream.set_stream(negate_sfx)
		sfx_stream.play()
	elif id == "newgame":
		sfx_stream.set_stream(newgame_sfx)
		sfx_stream.play()
		warning_stream.stop()
	elif id == "gameover":
		sfx_stream.set_stream(gameover_sfx)
		sfx_stream.play()
		warning_stream.stop()

func play_warning(value):
	if value:
		warning_stream.play()
	else:
		warning_stream.stop()

func _on_warning_sfx_finished():
	warning_stream.play()
