extends Coin

func _on_grab_area_body_entered(body: Node2D) -> void:
	super(body)
	body.velocity.y = -300
