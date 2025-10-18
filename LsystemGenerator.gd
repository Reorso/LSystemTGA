extends Node3D

class_name Plant

# Exposed parameters 
@export var axiom: String = "F"
@export var rules: Dictionary = { "F": "F[-F]F[+F]F" } 
@export var angle: float = 25.7
@export var iterations: int = 4
@export var length: float = 50.0

var current_string: String
var turtle_stack: Array = []
var drawing_commands: Array = []
var meshes: Array = []

func _ready():
	current_string = axiom
	for i in range(iterations):
		current_string = apply_rules(current_string)
		print_debug("current iteration, content: ", i, current_string)
	generate_meshes(current_string)
	#emit_signal("draw")  # Request a redraw

func apply_rules(string: String) -> String:
	var new_string: String = ""
	for analyzedChar in string:
		if analyzedChar in rules:
			new_string += rules[analyzedChar]
		else:
			new_string += analyzedChar
	return new_string

func prepare_drawing_commands(string: String):
	var turtle_pos: Vector2 = Vector2(0, 0)
	var turtle_angle: float = -90  # Pointing upwards initially
		
	turtle_stack.append([turtle_pos, turtle_angle])
	
	for analyzedChar in string:
		match analyzedChar:
			"F":
				var new_pos: Vector2 = turtle_pos + Vector2(cos(deg_to_rad(turtle_angle)), sin(deg_to_rad(turtle_angle))) * length
				drawing_commands.append({ "start": turtle_pos, "end": new_pos })
				turtle_pos = new_pos
			"X":
				var new_pos: Vector2 = turtle_pos + Vector2(cos(deg_to_rad(turtle_angle)), sin(deg_to_rad(turtle_angle))) * length
				#drawing_commands.append({ "start": turtle_pos, "end": new_pos })
				#turtle_pos = new_pos
			"+":
				turtle_angle += angle
			"-":
				turtle_angle -= angle
			"[":
				turtle_stack.append([turtle_pos, turtle_angle])
			"]":
				var state = turtle_stack.pop_back()
				turtle_pos = state[0]
				turtle_angle = state[1]

func _draw():
	print_debug("drawing ", drawing_commands)
	for command in drawing_commands:
		draw_line(command["start"], command["end"])

func draw_line(start: Vector3, end: Vector3):
	var mesh_instance = MeshInstance3D.new()
	var mesh = create_cylinder_mesh(length * 0.1, start.distance_to(end))
	mesh_instance.mesh = mesh
	mesh_instance.transform.origin = (start + end) / 2
	add_child(mesh_instance)
	mesh_instance.look_at(end, Vector3(0, 1, 0))
	meshes.append(mesh_instance)

func create_cylinder_mesh(radius: float, height: float) -> Mesh:
	var mesh = CylinderMesh.new()
	mesh.bottom_radius = radius
	mesh.top_radius = radius
	mesh.height = height
	return mesh


func generate_meshes(string: String):
	var turtle_pos: Vector3 = Vector3(0, 0, 0)
	var turtle_rot: Basis = Basis()

	for char in string:
		match char:
			"F":
				var new_pos: Vector3 = turtle_pos + turtle_rot * Vector3(0, 0, length)
				draw_line(turtle_pos, new_pos)
				turtle_pos = new_pos
			"+":
				turtle_rot = turtle_rot.rotated(Vector3(0, 1, 0), deg_to_rad(angle))
			"-":
				turtle_rot = turtle_rot.rotated(Vector3(0, 1, 0), deg_to_rad(-angle))
			"[":
				turtle_stack.append([turtle_pos, turtle_rot])
			"]":
				var state = turtle_stack.pop_back()
				turtle_pos = state[0]
				turtle_rot = state[1]
