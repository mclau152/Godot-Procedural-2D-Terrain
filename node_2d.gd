extends Node2D

@onready var mesh_instance = $MeshInstance2D
@onready var collision_polygon = $StaticBody2D/CollisionPolygon2D

const WIDTH = 30000
const HEIGHT = 600
const STEP_X = 20
const NUM_POINTS = WIDTH / STEP_X

var noise = FastNoiseLite.new()

func _ready():
	setup_noise()
	generate_cave()

func setup_noise():
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.003
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.fractal_octaves = 4
	noise.fractal_gain = 0.5

func generate_cave():
	var vertices = PackedVector2Array()
	var indices = PackedInt32Array()
	var collision_vertices = PackedVector2Array()

	for i in range(NUM_POINTS):
		var x = i * STEP_X
		var y_ceiling = noise.get_noise_2d(x * 0.1, 0.0) * (HEIGHT / 3) - (HEIGHT / 3)
		var y_floor = noise.get_noise_2d(x * 0.1, 100.0) * (HEIGHT / 4) + (HEIGHT / 2)

		vertices.append(Vector2(x, y_ceiling))
		vertices.append(Vector2(x, y_floor))
		collision_vertices.append(Vector2(x, y_ceiling))
		collision_vertices.append(Vector2(x, y_floor))

		if i < NUM_POINTS - 1:
			var j = i * 2
			indices.append_array([j, j+2, j+1, j+2, j+3, j+1])

	vertices.append_array([Vector2(WIDTH, HEIGHT), Vector2(0, HEIGHT)])
	collision_vertices.append_array([Vector2(WIDTH, HEIGHT), Vector2(0, HEIGHT)])

	create_mesh(vertices, indices)
	collision_polygon.polygon = collision_vertices

func create_mesh(vertices: PackedVector2Array, indices: PackedInt32Array):
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices

	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh_instance.mesh = array_mesh
