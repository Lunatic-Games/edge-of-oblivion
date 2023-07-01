extends CanvasLayer


const MAIN_MENU_SCENE: PackedScene = preload("res://UI/Menus/MainMenu/MainMenu.tscn")
const PARTICLES_FOLDER_PATH: String = "res://Data/Particles"
const UNITS_FOLDER_PATH: String = "res://Data/Occupants"


func _ready() -> void:
	# Give time for scene to display before precaching freezes everything, otherwise no wait screen
	await get_tree().process_frame
	await get_tree().process_frame
	
	var nodes: Array[Node] = []
	
	var particle_paths: Array[String] = FileUtility.get_all_files_under_folder(PARTICLES_FOLDER_PATH,
		".tscn")
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
	
	var unit_paths: Array[String] = FileUtility.get_all_files_under_folder(UNITS_FOLDER_PATH, ".tscn")
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
	get_tree().change_scene_to_packed(MAIN_MENU_SCENE)
