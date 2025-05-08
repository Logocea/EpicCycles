extends Node

@export var camera_path: NodePath
@export var pan_scalar: float = 1.0
@export var zoom_scalar: float = 1.0
@export var min_zoom: float = 0.01
@onready var camera: Camera2D = get_node(camera_path)

func _process(delta: float) -> void:
	var pan: Vector2
	
	if Input.is_action_pressed("pan_up"):
		pan += Vector2(0, -1.0) * pan_scalar
	if Input.is_action_pressed("pan_down"):
		pan += Vector2(0, 1.0) * pan_scalar
	if Input.is_action_pressed("pan_left"):
		pan += Vector2(-1.0, 0) * pan_scalar
	if Input.is_action_pressed("pan_right"):
		pan += Vector2(1.0, 0) * pan_scalar
		
	camera.translate(pan)
	
	var new_zoom: float = camera.zoom.x
	if Input.is_action_just_released("zoom_in"):
		new_zoom += zoom_scalar
	if Input.is_action_just_released("zoom_out"):
		new_zoom -= zoom_scalar
	
	var new_zoom_vec: Vector2 = Vector2(max(new_zoom, min_zoom), max(new_zoom, min_zoom))
	camera.zoom = new_zoom_vec
