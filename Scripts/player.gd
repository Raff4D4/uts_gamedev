extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D2

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_node_ready():
		update_animation(direction)
		
	move_and_slide()

func update_animation(direction: float) -> void:
	if animated_sprite == null:
		return

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if not is_on_floor():
		if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("jump"):
			animated_sprite.play("jump")
	elif direction != 0:
		if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("run"):
			animated_sprite.play("run")
	else:
		if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("idle"):
			animated_sprite.play("idle")
