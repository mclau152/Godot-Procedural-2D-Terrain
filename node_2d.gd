extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_rolling_hills()
	update_collision_polygon()

# Function to create the rolling hills mesh with smoother, larger terrain
func create_rolling_hills() -> void:
	# Create a new ArrayMesh
	var array_mesh = ArrayMesh.new()

	# Define the number of points and adjust hill width/height for smoother terrain
	var num_points = 200  # More points for smoother hills
	var hill_width = 40   # Wider hills
	var hill_height = 20  # Lower amplitude for gentler slopes

	# Generate vertices for the hills (smoother sine wave)
	var vertices = PackedVector2Array()
	for i in range(num_points):
		var x = i * hill_width
		var y = sin(i * 0.1) * hill_height  # Smaller frequency for smoother waves
		vertices.append(Vector2(x, y))
	
	# Add ground vertices to close the shape
	vertices.append(Vector2(hill_width * (num_points - 1), 300)) # Right ground point (300 for more depth)
	vertices.append(Vector2(0, 300)) # Left ground point
	
	# Create indices for the triangle faces
	var indices = PackedInt32Array()
	for i in range(num_points - 1):
		indices.append(i)
		indices.append(i + 1)
		indices.append(num_points) # Close the shape with the ground points

		indices.append(i + 1)
		indices.append(num_points + 1)
		indices.append(num_points)

	# Create a surface with vertices and indices
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices

	# Add the surface to the array mesh
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	# Assign the mesh to the existing MeshInstance2D
	var mesh_instance = $MeshInstance2D
	mesh_instance.mesh = array_mesh

# Function to update the existing CollisionPolygon2D
func update_collision_polygon() -> void:
	# Get the existing CollisionPolygon2D node
	var collision_polygon = $StaticBody2D/CollisionPolygon2D
	
	# Define the number of points and adjust hill width/height for smoother terrain
	var num_points = 200
	var hill_width = 40
	var hill_height = 20
	
	# Generate vertices for the collision (same as mesh vertices)
	var collision_vertices = []
	for i in range(num_points):
		var x = i * hill_width
		var y = sin(i * 0.1) * hill_height  # Same frequency for smoother collision shape
		collision_vertices.append(Vector2(x, y))
	
	# Add ground vertices to close the collision shape
	collision_vertices.append(Vector2(hill_width * (num_points - 1), 300)) # Right ground point
	collision_vertices.append(Vector2(0, 300)) # Left ground point

	# Assign the vertices to the existing CollisionPolygon2D
	collision_polygon.polygon = collision_vertices
