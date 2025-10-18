extends MeshInstance3D

#var rings = 50
#var radial_segments = 50
#var radius = 1

func _ready():
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	# PackedVector**Arrays for mesh construction.
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()



	var startPoint = Vector3(0,0,0)	
	var dimension = Vector2(10,10)
	var resolution = 1

	for y in range(dimension.y):
		for x in range(dimension.x):
			var vert = Vector3 (0,0,0)
			vert.x = (x-1) * resolution + startPoint.x
			vert.z = (y-1) * resolution + startPoint.z
			vert.y = 0

			verts.append(vert)
			normals.append(vert.normalized())
			uvs.append(Vector2(x,y))
			if x < dimension.x and y < dimension.y:
				indices.append(x+y*dimension.x)
				indices.append(x+1+y*dimension.x)
				indices.append(x+(y+1)*dimension.x)
				
				indices.append(x+1+y*dimension.x)
				indices.append(x+1+(y+1)*dimension.x)
				indices.append(x+(y+1)*dimension.x)

	# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices

	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.
	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
