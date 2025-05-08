extends Node

signal epicycle_selected(which_node: Node2D)
signal epicycle_deselected

@export var sim_status: Resource

@export var panel_path: NodePath
@onready var panel: Control = get_node(panel_path)

@onready var selected_epicycle: Node2D = null

func show_panel() -> void:
	sim_status.sim_running = false
	panel.show()
	
func hide_panel() -> void:
	sim_status.sim_running = true
	panel.hide()
	selected_epicycle = null
	epicycle_deselected.emit()
	
func _ready() -> void:
	hide_panel()

func _on_resume_button_pressed() -> void:
	hide_panel()

func _process(delta: float) -> void:
	if Input.is_action_just_released("toggle_pause"):
		if sim_status.sim_running:
			show_panel()
		else:
			hide_panel()
