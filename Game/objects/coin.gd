extends AnimatedSprite2D
class_name Coin
## class_name for custom classes can be used to allow other classes to easily extend them
## just like how Coin extends AnimatedSprite2D we can inherit stuff from Coin by doing "extends Coin"

func _on_grab_area_body_entered(body: Node2D) -> void:
	## We can call Global by it's global variable name.
	## Global nodes and scripts are added by doing Project->Project Settings->Globals
	Global.add_points(1)
	
	## queue_free() is used to delete this node
	queue_free()
