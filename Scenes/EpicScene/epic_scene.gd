extends Node

@export var sim_status: Resource

@export var panel_path: NodePath
@onready var panel: Control = get_node(panel_path)

func show_panel() -> void:
	sim_status.sim_running = false
	panel.show()
	
func hide_panel() -> void:
	sim_status.sim_running = true
	panel.hide()
	
func _ready() -> void:
	hide_panel()

func _on_resume_button_pressed() -> void:
	hide_panel()
