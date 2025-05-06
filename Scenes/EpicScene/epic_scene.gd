extends Node2D

@export var sim_status: Resource

func _on_toggle_pause_button_pressed() -> void:
	sim_status.sim_running = !sim_status.sim_running
