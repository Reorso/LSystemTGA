@tool
extends MeshInstance3D

@export var rings = 50:
	set(value):
		rings = value
		_ready()  # <-- this runs whenever you change `radius` in the Inspector

@export var radial_segments = 50:
	set(value):
		radial_segments = value
		_ready()  # <-- this runs whenever you change `radius` in the Inspector

@export var radius = 1:
	set(value):
		radius = value
		_ready()  # <-- this runs whenever you change `radius` in the Inspector

@export var mid_lenght = 10:
	set(value):
		mid_lenght = value
		_ready()  # <-- this runs whenever you change `radius` in the Inspector
		
@export var offset = 0.1:
	set(value):
		offset = value
		_ready()  # <-- this runs whenever you change `radius` in the Inspector

		# PackedVector**Arrays for mesh construction.
var verts
var uvs
var normals
var indices
var surface_array


func _ready():
	
	print("reloaded")
	surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	verts = PackedVector3Array()
	uvs = PackedVector2Array()
	normals = PackedVector3Array()
	indices = PackedInt32Array()
	# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	createSphere()
	mesh = ArrayMesh.new()
	#var new_mesh = load("res://sphere.tres")
#	mesh = new_mesh
	print_debug("this is the mesh: ", mesh)
	# No blendshapes, lods, or compression used.
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	# Saves mesh to a .tres file with compression enabled.
	
	#ResourceSaver.save(mesh, "res://sphere.tres", ResourceSaver.FLAG_COMPRESS)

func createSphere():
	var totOffset = 0
	# Loop over rings.
	for lat in range(rings + 1):
		var y = float(lat) / rings
		var x = sin(PI * y) 
		var z = cos(PI * y) - ((totOffset) * offset)
		if(lat == rings/2):
			for k in range(mid_lenght):
				createRing(y,x,z - (k * offset), lat+k)
			totOffset = mid_lenght - 1
		else:
			createRing(y, x,z, lat+totOffset)
		# Loop over segments in ring.
	return surface_array
 
func createRing(y,x,z,finalLat):
	for lon in range(radial_segments + 1):
		var y2 = float(lon) / radial_segments
		var x2 = sin(y2 * PI * 2.0)
		var z2 = cos(y2 * PI * 2.0)
		var vert = Vector3(x2 * x , z , z2 * x) * radius

		verts.append(vert)
		normals.append(vert.normalized())
		uvs.append(Vector2(y2, y))

		# Create triangles in ring using indices.
		if finalLat > 0 and lon > 0:
			indices.append(((finalLat-1)*(radial_segments+1)) + lon - 1)
			indices.append(((finalLat-1)*(radial_segments+1)) + lon)
			indices.append(((finalLat)*(radial_segments+1)) + lon - 1)

			indices.append(((finalLat-1)*(radial_segments+1)) + lon)
			indices.append(((finalLat)*(radial_segments+1)) + lon)
			indices.append(((finalLat)*(radial_segments+1)) + lon - 1)

func createTriangles(surface_array):
	# PackedVector**Arrays for mesh construction.


	## Insert code here to generate mesh ##
	var startPoint = Vector3(0,0,0)
	var dimension = Vector2(10,10)
	var resolution = 1

	for i in range(dimension.y):
		for g in range(dimension.x):
			var vert = Vector3 (0,0,0)
			vert.x = i * resolution + startPoint.x
			vert.z = g * resolution + startPoint.z
			vert.y = 0
			verts.append(vert)
			normals.append(vert.normalized())
			uvs.append(Vector2(i,g))
			if g < dimension.y-2 and i < dimension.x-2:
				indices.append(i*g+i)
				indices.append(i*g+i+1)
				indices.append(i*g+i+2)


	# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	return surface_array
