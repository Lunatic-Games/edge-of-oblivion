extends CanvasLayer

const PARTICLES_FOLDER_PATH: String = "res://Data/Particles"

const MISC_PATHS = [
	"res://Data/Units/Enemies/Faded/Faded.tscn",
	"res://Data/Units/Enemies/ForswornPike/ForswornPike.tscn",
	"res://Data/Units/Enemies/LostRanger/LostRanger.tscn",
	"res://Data/Units/Enemies/Bosses/ForgottenKing/ForgottenKing.tscn"
]

const PLAYER_PATH = "res://Data/Units/Player/Player.tscn"  # Needs special treatment

func _ready() -> void:
	# Give the time to render the screen before doing this blocking operation
	await get_tree().process_frame
	await get_tree().process_frame
	
	var nodes: Array[Node] = []
	
	var particle_paths: Array[String] = get_particle_paths()
	var n_particles_precaching: int = 0
	for path in particle_paths:
		var scene: PackedScene = load(path)
		var particles: Node2D = scene.instantiate()
		nodes.append(particles)
		add_child(particles)
		n_particles_precaching += 1
		
		# If the particles aren't set to emit automatically we need to force to precache it
		if "emitting" in particles:  
			particles.emitting = true
	
	var player_scene: PackedScene = load(PLAYER_PATH)
	var player: Player = player_scene.instantiate()
	nodes.append(player)
	add_child(player)
	player.set_physics_process(false)  # Otherwise movement handling will crash
	
	var n_misc_precaching: int = 0
	for path in MISC_PATHS:
		var scene: PackedScene = load(path)
		var instance: Node = scene.instantiate()
		nodes.append(instance)
		add_child(instance)
		n_misc_precaching += 1
	
	print("Precaching {0} particles, the player, and {1} other nodes...".format(
		[n_particles_precaching, n_misc_precaching]))
	
	# Give some time for particles to process before cleaning up
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Good to go!
	get_tree().change_scene_to_file("res://Menus/MainMenu/MainMenu.tscn")


func get_particle_paths() -> Array[String]:
	var paths: Array[String] = []
	var directory_paths_stack: Array[String] = [PARTICLES_FOLDER_PATH]
	
	while directory_paths_stack.size() > 0:
		var current_director_path: String = directory_paths_stack.pop_back()
		var current_directory: DirAccess = DirAccess.open(current_director_path)
		current_directory.list_dir_begin()
		
		var file_name: String = current_directory.get_next()
		while file_name != "":
			var current_file_path: String = current_director_path + "/" + file_name
			
			if current_directory.current_is_dir():
				directory_paths_stack.push_back(current_file_path)
			# Check for .tscn files (editor) or .tscn.remap (exported projects)
			elif file_name.ends_with(".tscn") or file_name.ends_with(".tscn.remap"):
				# DirAccess finEdds them as .remap but for loading to work it needs to be removed
				current_file_path = current_file_path.trim_suffix(".remap")
				paths.append(current_file_path)
			
			file_name = current_directory.get_next()
		
		current_directory.list_dir_end()
	
	return paths
