extends VBoxContainer

@export var epicycles_path: NodePath
@onready var epicycle_scene: PackedScene = preload("res://Scenes/Epicycle/epicycle.tscn")

var selected_epicycle: Node2D = null

func fix_offset() -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	offset_left = mouse_pos.x
	offset_top = mouse_pos.y

func fix_name() -> void:
	if !selected_epicycle:
		print("fix_number_label called while selected_epicycle is null")
		return
	$Name.text = selected_epicycle.name

func _on_epic_scene_epicycle_selected(which_node: Node2D) -> void:
	selected_epicycle = which_node
	fix_name()
	fix_offset()
	show()

func _on_add_epicycle_button_pressed() -> void:
	var epicycles: Node2D = get_node(epicycles_path)
	var epicycle_node: Node2D = epicycle_scene.instantiate()
	
	epicycle_node.parent_epicycle = selected_epicycle.get_path()
	epicycle_node.canonical_radius = Vector2(float($NewEpicycleX.text), float($NewEpicycleY.text))
	epicycle_node.rotational_period = float($NewEpicyclePeriod.text)
	
	epicycles.add_child(epicycle_node)
	
func _on_epic_scene_epicycle_deselected() -> void:
	hide()

func _on_draw_check_button_toggled(toggled_on: bool) -> void:
	selected_epicycle.draws = toggled_on
