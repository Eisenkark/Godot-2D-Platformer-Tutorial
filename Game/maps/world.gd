extends Node2D
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var collision_polygon_2d: CollisionPolygon2D = $Collision/CollisionPolygon2D

func _ready() -> void:
	## To easily test things in a platformer we can copy a colored polygon's points to a collision polygon
	collision_polygon_2d.polygon = polygon_2d.polygon
