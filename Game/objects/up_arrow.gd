extends Coin

func _on_grab_area_body_entered(body: Node2D) -> void:
	## Since we extend Coin we can call super() with its parameters to call the parent class's grab function
	super(body)
	
	## We can check if a node is of a certain type
	## this is necessary as CharacterBody2D has velocity but other Node2D nodes might not have velocity
	if body is CharacterBody2D:
		## We can modify variables of the thing that touched this red arrow.
		## This will make whatever it touches bounce upwards
		body.velocity.y = -300
