extends CharacterBody2D

var input
@export var speed = 100.0
@export var gravity = 10 

var jump_count = 0
@export var max_jump = 2
@export var jump_force = 500

var current_state = player_states
enum player_states {MOVE, SWORD, DEAD}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$sword/sword_hitbox.disabled = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement(delta)
	
func gravity_force():
	velocity.y +=gravity

func movement(delta):
	input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input == 0:
		velocity.x = 0
		$animation.play("idle")
	
	if input != 0:
		if input > 0:
			velocity.x += speed * delta
			velocity.x = clamp(speed,100.0, speed)
			$Sprite2D.scale.x = 1
			$sword.position.x = 15
			$animation.play("walk")
			
		if input < 0:
			velocity.x -= speed * delta
			velocity.x = clamp(-speed,100.0, -speed)
			$Sprite2D.scale.x = -1
			$sword.position.x = -15
			$animation.play("walk")
			
		
#jump?
	if is_on_floor():
		jump_count = 0
		
	if !is_on_floor():
		if velocity.y < 0:
			$animation.play("jump")
		if velocity.y > 0:
			$animation.play("fall")
		

	if Input.is_action_pressed("ui_up") && is_on_floor() && jump_count < max_jump:
		jump_count += 1
		velocity.y = -jump_force
		velocity.x = input
		print(jump_count)
		print(velocity.y)
	
	if Input.is_action_just_pressed("ui_up") && !is_on_floor() && jump_count < max_jump:
		jump_count += 1
		velocity.y = -jump_force
		velocity.x = input
		print(jump_count)
		print(velocity.y)

	if Input.is_action_just_released("ui_up") && !is_on_floor() && jump_count < max_jump:
		velocity.y -= gravity
		velocity.x = input

		
	move_and_slide()
	gravity_force()
	
func sword_atack():
	pass
