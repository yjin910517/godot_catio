extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	amount = 16
	
	process_material.gravity = Vector3(0,0,0)
	# process_material.scale min = 0.5 max = 1 (can only be set in inspector)
	
	lifetime = 0.2
