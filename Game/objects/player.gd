extends CharacterBody2D

@export var JUMP_HEIGHT: float = 10
@export var WALK_SPEED: float = 10
@export var ACCELERATION: float = 100
@export var FRICTION: float = 100

func _physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("ui_left", "ui_right")
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y -= JUMP_HEIGHT
	else:
		velocity += get_gravity() * delta
		if velocity.y < -JUMP_HEIGHT/2 and Input.is_action_just_released("ui_accept"):
			velocity.y /= 2
	
	var used_speed: float = WALK_SPEED * 2 if Input.is_action_pressed("action_run") else WALK_SPEED
	if direction:
		velocity.x = move_toward(velocity.x, used_speed * direction, delta * ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * FRICTION)
	
	move_and_slide()
