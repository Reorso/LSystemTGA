#extends Node
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
#
#class LSystem:
	#var rules
	#var currentState = ""
	#
	#func _getNewGeneration():
		##this will go through each state and try to apply the rules
		#while currentState.count() > 0:
			#foreach rule in rules:
				#if rule.count() < currentState.count():
					#currentState
		#pass
		
		
#extends Node2D
#
#class_name Plant
#
#var axiom: String = "F"
#var rules: Dictionary = {
	#"F": "F[-F]F[+F]F"  # Example rule for a fern-like plant
#}
#var angle: float = 25.7
#var iterations: int = 4
#var length: float = 100
#
#var current_string: String
#var turtle_stack: Array = []
#
#func _ready():
	#current_string = axiom
	#for i in range(iterations):
		#current_string = apply_rules(current_string)
	##draw_plant(current_string)
#
#func apply_rules(string: String) -> String:
	#var new_string: String = ""
	#for letter in string:
		#if letter in rules:
			#new_string += rules[letter]
		#else:
			#new_string += letter
	#return new_string
	#
#func _draw() -> void:
	#draw_plant(current_string)
#
#func draw_plant(string: String):
	#var turtle_pos: Vector2 = Vector2(0, 0)
	#var turtle_angle: float = -90  # Pointing upwards initially
	#turtle_stack.append([turtle_pos, turtle_angle])
	#
	#for letter in string:
		#match letter:
			#"F":
				#var new_pos: Vector2 = turtle_pos + Vector2(cos(deg_to_rad(turtle_angle)), sin(deg_to_rad(turtle_angle))) * length
				#draw_line(turtle_pos, new_pos, Color(0, 1, 0), 2)
				#turtle_pos = new_pos
			#"+":
				#turtle_angle += angle
			#"-":
				#turtle_angle -= angle
			#"[":
				#turtle_stack.append([turtle_pos, turtle_angle])
			#"]":
				#var state = turtle_stack.pop_back()
				#turtle_pos = state[0]
				#turtle_angle = state[1]
				
extends Node2D

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

func _ready():
	current_string = axiom
	for i in range(iterations):
		current_string = apply_rules(current_string)
		print_debug("current iteration, content: ", i, current_string)
	prepare_drawing_commands(current_string)
	emit_signal("draw")  # Request a redraw

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
	#print_debug("drawing ", drawing_commands)
	for command in drawing_commands:
		draw_line(command["start"], command["end"], Color(1, 1, 1), 2)
		draw_circle(command["start"], 3, Color(1, 0, 0))  # Debug circle to mark start points
