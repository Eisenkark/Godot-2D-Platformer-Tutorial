extends CharacterBody2D
class_name Player

@export var JUMP_HEIGHT: float = 300
@export var WALK_SPEED: float = 100
@export var ACCELERATION: float = 600
@export var AIR_ACCELERATION: float = 300
@export var FRICTION: float = 800
@export var RUN_SPD_MULTIPLIER: float = 2

@onready var body_sprite: AnimatedSprite2D = $BodySprite

var respawn_position: Vector2

func _ready():
	respawn_position = global_position

func _physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		var used_speed: float = WALK_SPEED * RUN_SPD_MULTIPLIER if Input.is_action_pressed("action_run") else WALK_SPEED
		
		if is_on_floor():
			body_sprite.speed_scale = velocity.x/WALK_SPEED
			body_sprite.flip_h = direction < 0
			
			if clampi(velocity.x, -1, 1) != 0 and clampi(direction, -1, 1) != clampi(velocity.x, -1, 1):
				velocity.x = move_toward(velocity.x, used_speed * direction, delta * FRICTION)
				body_sprite.play("skid")
			else:
				velocity.x = move_toward(velocity.x, used_speed * direction, delta * ACCELERATION)
				body_sprite.play("walk")
		else:
			velocity.x = move_toward(velocity.x, used_speed * direction, delta * AIR_ACCELERATION)
		
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, delta * FRICTION)
		body_sprite.play("stand")
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y -= JUMP_HEIGHT
			body_sprite.play("jump")
	else:
		velocity += get_gravity() * delta
		if velocity.y < -JUMP_HEIGHT/2 and Input.is_action_just_released("ui_accept"):
			velocity.y /= 2
		if velocity.y > 0:
			body_sprite.play("fall")
	
	if global_position.y > 640:
		die()
	
	move_and_slide()

func die():
	global_position = respawn_position

func _on_hurt_area_body_entered(body: Node2D) -> void:
	die()
