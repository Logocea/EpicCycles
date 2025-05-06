extends VBoxContainer

var can_show: bool = false

var last_mouse_pos: Vector2
var move_menu: bool = false
var move_factor: float = 5.0

func _process(delta: float) -> void:

	if Input.is_action_pressed("show_context_menu"):
		last_mouse_pos = get_global_mouse_position()

		if visible:
			move_menu = true
		elif can_show:
			offset_left = last_mouse_pos.x
			offset_top = last_mouse_pos.y
			show()
	
	if move_menu and can_show:
		offset_left += (last_mouse_pos.x - offset_left) * delta * move_factor
		offset_top += (last_mouse_pos.y - offset_top) * delta * move_factor

	if not can_show:
		hide()

func _on_close_context_menu_button_pressed() -> void:
	hide()

func _on_toggle_pause_button_pressed() -> void:
	can_show = not can_show
