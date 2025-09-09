extends CharacterBody2D
class_name Player

## Let's define some custom variables that our Player class will use!
## @export allows us to modify the variables per Node we instantiate
## with @export you can easily change these values during run time to test movement better
@export var JUMP_HEIGHT: float = 300
@export var WALK_SPEED: float = 100
@export var ACCELERATION: float = 600
@export var AIR_ACCELERATION: float = 300
@export var FRICTION: float = 800
@export var RUN_SPD_MULTIPLIER: float = 2

## @onready is called when the node is fully ready meaning every aspect of it is in the scene tree
## @onready is used for referring to children of our Nodes
## The $ is used to reference our children
## The $ is like knowing a person only by physical appearance
## But what if that person changes their shirt? It's like if instead $BodySprite was $MainBodySprite

## If we were changing values of the node by $ we would need to change it everywhere!
## Instead we can name it body_sprite just like learning someone's name
## This will make it much easier to change the values and call the methods of our AnimatedSprite2D
@onready var body_sprite: AnimatedSprite2D = $BodySprite

## Here we have a basic variable, it's type is a Vector2 so it has an x and y value.
var respawn_position: Vector2

## This is our _ready() method, it's a built-in method of every Node
func _ready() -> void:
	## _ready() happens when the scene is added to the scene tree
	
	## Let's use this to set a respawn position
	## This makes it easy because wherever you place the player in the scene is where it will respawn
	respawn_position = global_position

## _physics_process() is a built-in method
func _physics_process(delta: float) -> void:
	## _physics_process() happens every physics frame, we'll use this to move and control our character
	## If you wanted something every frame that wasn't physics related use _process() instead, it's also a built-in method
	
	## Direction is taken from the inputs for ui_left and ui_right
	## The names ui_left and ui_right are taken from the Input Map you can swap them for other input names
	
	## The Input Map can be found through Project->Project Settings->Input Map
	## If some inputs such as "ui_left" are not showing these are built-in controls
	## To show built-in controls there's a toggle labeled "Show Built-in Actions"
	var direction: float = Input.get_axis("ui_left", "ui_right")
	
	## If there's a direction we want to move the player in the horizontal direction
	if direction:
		## Instead of using WALK_SPEED and multiplying it later it's better to have a variable that can be changed
		## used_speed is good since we can multiply it by RUN_SPD_MULTIPLIER if "action_run" is held down
		
		## In Godot you can set variables using if statements as long as there is an else to fall back on
		## Here it sets used_speed to be our running speed if our run key is set, else we use our normal walk speed
		var used_speed: float = WALK_SPEED * RUN_SPD_MULTIPLIER if Input.is_action_pressed("action_run") else WALK_SPEED
		
		## We're checking is_on_floor() so we know whether to use floor acceleration or air acceleration
		if is_on_floor():
			## We're setting attributes of body_sprite here, to do that you call the reference name and then it's attributes
			## body_sprite's speed_scale is set this way so our player's animation moves faster if we're running
			body_sprite.speed_scale = velocity.x/WALK_SPEED
			## body_sprite gets flip if the direction is less than 0, turning him around
			body_sprite.flip_h = direction < 0
			
			## This is tricky but let's break it down! *funky music starts playing
			## clampi takes 3 variables: variable to set, lowest value, highest value
			## clampi is different from clamp since it returns integers only
			if clampi( velocity.x, -1, 1 ) != 0 and clampi( direction, -1, 1 ) != clampi( velocity.x, -1, 1 ):
				## This ^^^ if statement will check if we should make our character skid
				## We skid if our clampped velocity.x is not 0 and if clampped velocity.x is different from direction
				## Skidding will be used for when the character is moving in one direction but decides to turn around while moving
				velocity.x = move_toward( velocity.x, used_speed * direction, delta * FRICTION )
				body_sprite.play("skid")
			else:
				
				## We're walking! We don't want a 0 to 100 speed however, so we use ACCELERATION!
				## move_toward is a basic function that isn't tied to a specific type of node, you can tell by it's purple text color
				## move_toward takes 3 methods: variable to change, target value, change per frame
				velocity.x = move_toward( velocity.x, used_speed * direction, delta * ACCELERATION )
				## Notice ^^^ We have acceleration but we multiply it by delta
				## delta is used for frame events where we are changing values incrementally
				## this prevents any bugs that could be caused from lag or a slower computer
				
				## delta value-wise is the time elapsed since the previous frame
				
				## Here we use a method of our AnimatedSprite2D called play()
				## This causes our body_sprite to play a new animation that we previously made in our AnimatedSprite2D
				body_sprite.play("walk")
		else:
			## To make controlling your player feel smoother it's recommended to have a different acceleration when in the air
			velocity.x = move_toward(velocity.x, used_speed * direction, delta * AIR_ACCELERATION)
	
	elif is_on_floor():
		## Instead of acceleration we'll use friction just for fun
		## The only difference between ACCELERATION and FRICTION is the numerical value
		velocity.x = move_toward(velocity.x, 0, delta * FRICTION)
		body_sprite.play("stand")
	
	## This if statement checks if the player is on the floor
	## is_on_floor() is a method of CharacterBody2D (the node type that this player is)
	if is_on_floor():
		## If we press ui_accept let's jump!
		if Input.is_action_just_pressed("ui_accept"):
			## Notice, we are subtracting JUMP_HEIGHT this is because as we drop lower in our level our y value increases!
			velocity.y -= JUMP_HEIGHT
			body_sprite.play("jump")
	else:
		## We are no longer on the floor so let's add our gravity, get_gravity() returns the default gravity from our project settings
		## You can change gravity by doing Project->Project Settings->General->Physics->2D->Default Gravity
		
		## Since we're changing this incrementally we use delta
		velocity += get_gravity() * delta
		
		## Giving our player is a sense of control can reduce frustration so let's give them control in their jump
		## We can easily have variable jump height by halving their vertical velocity
		## Notice: Since the direction UP is y negative we check if our velocity.y is less than our negative JUMP_HEIGHT divided by 2
		## We also check if our jump_button was let go
		if velocity.y < -JUMP_HEIGHT/2 and Input.is_action_just_released("ui_accept"):
			velocity.y /= 2
		
		## This is just for fun, if our velocity.y is greater than 0 we're falling down so play an animation for that
		if velocity.y > 0:
			body_sprite.play("fall")
	
	## We're now checking our player's position
	## We can do this in two ways, either with the variable position or global_position
	## Since we don't want to care what the parent node of the player is we'll use global_position
	if global_position.y > 640:
		## we'll now call our custom method die()
		die()
	
	## WARNING
	## All other comments may help you but this is crucial
	## To get your CharacterBody2D to move you must call either move_and_slide() or move_and_collide()
	## move_and_slide() is much easier to implement and has a lot more use cases
	## move_and_slide() will use the velocity of our CharacterBody2D (our player) to move it
	## the slide part comes in if our player hits a wall, when they hit a wall they will properly stop at that wall
	move_and_slide()
	
	## Remember, if you don't call move_and_slide() the CharacterBody2D won't move

## Here's our custom method it returns void
## Void doesn't return anything, if you wanted a method to return an integer or a String you would return that instead of void
func die() -> void:
	## Set our global_position to be the respawn_position we set in _ready()
	global_position = respawn_position

## 
func _on_hurt_area_body_entered(body: Node2D) -> void:
	## Our hurt area was entered so we must DIE!
	die()
