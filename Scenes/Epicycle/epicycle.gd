extends Node2D

@onready var root_node: Node = get_node("../../..")

@export var sim_status: Resource

@export var parent_epicycle: NodePath
@export var canonical_radius: Vector2
@export var rotational_period: float

@onready var time_passed: float = 0
@onready var current_angle: float = canonical_radius.angle()
@onready var current_radius: Vector2 = canonical_radius

@onready var visual_line: Line2D = $VisualLine

var parent_epicycle_node: Node2D

func update_parent_epicycle(new_path: NodePath) -> void:
	parent_epicycle = new_path
	parent_epicycle_node = get_node(parent_epicycle)

func fix_time_passed(delta: float) -> void:
	time_passed += delta

func fix_angle() -> void:
	current_angle = 2.0 * PI * 1.0/float(rotational_period) * time_passed

func fix_current_radius() -> void:
	current_radius = canonical_radius.rotated(current_angle)

func _ready() -> void:
	if parent_epicycle:
		update_parent_epicycle(parent_epicycle)

func apply_simulation_logic(delta: float) -> void:
	if parent_epicycle_node:
		global_position = parent_epicycle_node.global_position + parent_epicycle_node.current_radius

	fix_time_passed(delta)
	fix_angle()
	fix_current_radius()

func update_visual_line() -> void:
	visual_line.points[1] = current_radius

func update_collision_shape() -> void:
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = Vector2(canonical_radius.length(), 20)
	var shape_node: CollisionShape2D = $Area2D/CollisionShape2D
	shape_node.rotation = current_radius.angle()
	shape_node.position = current_radius/2.0
	shape_node.shape = shape

@onready var prior_sim_running: bool = sim_status.sim_running

func _physics_process(delta: float) -> void:
	if sim_status.sim_running:
		apply_simulation_logic(delta)
		update_visual_line()
		update_collision_shape()
		if prior_sim_running == false:
			$AnimationPlayer.play("RESET")
	
	prior_sim_running = sim_status.sim_running
	
func _on_area_2d_mouse_entered() -> void:
	if !sim_status.sim_running and !root_node.selected_epicycle:
		$AnimationPlayer.play("line_hovered")

func _on_area_2d_mouse_exited() -> void:
	if !sim_status.sim_running and !root_node.selected_epicycle:
		$AnimationPlayer.play("RESET")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and !sim_status.sim_running:
		root_node.show_panel()
		root_node.selected_epicycle = self
