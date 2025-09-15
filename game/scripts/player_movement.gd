extends CharacterBody2D


@onready var sprite_anims = $AnimatedSprite2D
@onready var sfx = $AudioStreamPlayer2D
@onready var shuriken = $shuriken
@onready var weapons_anim = $AnimationPlayer
@onready var shuriken_sfx = preload("res://assets/sfx/shuriken_thrown.mp3")
@onready var jump_sfx = preload("res://assets/sfx/jump.wav")


const SPEED = 125.0
const JUMP_VELOCITY = -300.0

var can_throw := true
var can_move := true
var debounce := false 

func _ready() -> void:
	can_move = true
	sprite_anims.play("idle")

func _physics_process(delta: float) -> void:
	
	if !can_move:
		sprite_anims.play("run")
		sprite_anims.flip_h = false
		velocity.x = SPEED
		move_and_slide()
		return
		
	if !is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y > 0 and !debounce:
			sprite_anims.play("fall")
			debounce = !debounce
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and can_throw:
		sprite_anims.play("jump")
		velocity.y = JUMP_VELOCITY
		
		sfx.stream = jump_sfx
		sfx.play()
		debounce = false
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction and can_throw:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			sprite_anims.play("run")
		if direction > 0:
			sprite_anims.flip_h = false
		else:
			sprite_anims.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0 and can_throw:
			sprite_anims.play("idle")
			
	if Input.is_action_just_pressed("throw") and can_throw:
		can_throw = false
		sfx.stream = shuriken_sfx
		sfx.play()
		sprite_anims.play("shuriken_throw")
		
		
		var weapons_anim_direction
		var shuriken_direction
		
		if sprite_anims.flip_h:
			shuriken_direction = 1
			weapons_anim_direction = "_left"
		else:
			shuriken_direction = -1
			weapons_anim_direction = "_right"
		
		weapons_anim.play("throw_shuriken" + weapons_anim_direction)
		velocity.x = 5 * SPEED * shuriken_direction
		
		await sprite_anims.animation_finished
		
		weapons_anim.play("RESET")
		can_throw = true
		
	move_and_slide()

func _on_dojo_body_entered(_body: Node2D) -> void:
	can_move = false # Replace with function body.
	
