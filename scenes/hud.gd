extends CanvasLayer

@onready var menu_panel = $Control/MenuPanel

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func _on_h_slider_2_value_changed(value):
	Global.sensitivity = value

func _on_h_slider_3_value_changed(value):
	Global.rot_sensitivity = value

func _on_menu_button_up():
	Global.play_sfx("pause")
	if menu_panel.visible:
		menu_panel.visible = false
	else:
		menu_panel.visible = true
