extends CanvasLayer

const PARTICLES = [
	"res://Data/Particles/Campfire/CampfireParticles.tscn",
	"res://Data/Particles/Damaged/DamagedParticles.tscn",
	"res://Data/Particles/DraculasKnives/DraculasKnivesStab.tscn",
	"res://Data/Particles/DragonCloak/DragonCloakOnHit.tscn",
	"res://Data/Particles/DragonCloak/FireRingSping.tscn",
	"res://Data/Particles/Hammer/HammerParticles.tscn",
	"res://Data/Particles/Healing/HealthParticles.tscn",
	"res://Data/Particles/HolyFire/HolyFireParticles.tscn",
	"res://Data/Particles/LevelUp/LevelUpParticles.tscn",
	"res://Data/Particles/LightningBow/LightningBowEffect.tscn",
	"res://Data/Particles/Slash/SlashParticles.tscn",
	"res://Data/Particles/StrayArquebus/ArquebusBlast.tscn",
	"res://Data/Particles/TaintedFlask/TaintedFlaskParticles.tscn",
	"res://Data/Particles/UIParticles/RayParticles.tscn",
]

const ENEMIES = [
	"res://Data/Units/Enemies/Faded/Faded.tscn",
	"res://Data/Units/Enemies/ForswornPike/ForswornPike.tscn",
	"res://Data/Units/Enemies/LostRanger/LostRanger.tscn",
	"res://Data/Units/Enemies/Bosses/ForgottenKing/ForgottenKing.tscn"
]

func _ready() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	
	for path in PARTICLES:
		var scene = load(path)
		var particles = scene.instantiate()
		add_child(particles)
		if "emitting" in particles:
			particles.emitting = true
	
	for path in ENEMIES:
		var scene = load(path)
		var enemy = scene.instantiate()
		add_child(enemy)

	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Menus/MainMenu/MainMenu.tscn")


#func load_particles():
#	var directories = [PARTICLES_FOLDER]
#	while directories.size() > 0:
#		var current_director_path = directories.pop_front()
#		var current_directory = DirAccess.open(current_director_path)
#		current_directory.list_dir_begin()
#		var file_name = current_directory.get_next()
#		while file_name != "":
#			if current_directory.current_is_dir():
#				directories.push_back(current_director_path + "/" + file_name)
#			elif file_name.ends_with(".tscn"):
#				var particles = load(current_director_path + "/" + file_name)
#				if particles != null:
#					print("Pre-caching particles at path: " + current_director_path + "/" + file_name)
#					var particles_instance = particles.instantiate()
#					add_child(particles_instance)
#			file_name = current_directory.get_next()
#		current_directory.list_dir_end()
