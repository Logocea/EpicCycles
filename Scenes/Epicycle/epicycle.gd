extends Node2D

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

func _physics_process(delta: float) -> void:
    if sim_status.sim_running:
        apply_simulation_logic(delta)
        update_visual_line()
    