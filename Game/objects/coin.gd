extends AnimatedSprite2D
class_name Coin

func _on_grab_area_body_entered(body: Node2D) -> void:
	Global.add_points(1)
	queue_free()
