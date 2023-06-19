extends CanvasLayer

const PARTICLES_FOLDER_PATH: String = "res://Data/Particles"
const UNITS_FOLDER_PATH: String = "res://Data/Units"


func _ready() -> void:
	# Give time for scene to display before precaching freezes everything, otherwise no wait screen
	await get_tree().process_frame
	await get_tree().process_frame
	
	var nodes: Array[Node] = []
	
	var particle_paths: Array[String] = get_all_scene_paths_under_folder(PARTICLES_FOLDER_PATH)
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
	
	var unit_paths: Array[String] = get_all_scene_paths_under_folder(UNITS_FOLDER_PATH)
	var n_misc_precaching: int = 0
	for path in unit_paths:
		var scene: PackedScene = load(path)
		var unit: Node = scene.instantiate()
		nodes.append(unit)
		add_child(unit)
		n_misc_precaching += 1
		
		unit.set_physics_process(false)  # Otherwise player movement handling will crash
	
	print("Precaching {0} particles and {1} units...".format(
		[n_particles_precaching, n_misc_precaching]))
	
	# Give some time for particles to process before cleaning up
	await get_tree().process_frame
	await get_tree().process_frame
	
	# Good to go!
	get_tree().change_scene_to_file("res://Menus/MainMenu/MainMenu.tscn")


func get_all_scene_paths_under_folder(folder_path: String) -> Array[String]:
	var paths: Array[String] = []
	var directory_paths_stack: Array[String] = [folder_path]
	
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
