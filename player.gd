@tool
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export_custom(PROPERTY_HINT_LINK, "suffix:px") var size: Vector2 = Vector2(40, 80):
	get:
		return size
	set(value):
		size = value
		if is_node_ready():
			_update_size()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	_update_size()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _update_size():
	sprite.position = Vector2(0, -size.y/2)
	sprite.scale = size
	
	collision_shape.position = Vector2(0, -size.y/2)
	if collision_shape.shape is CapsuleShape2D:
		collision_shape.shape.radius = size.x/2
		collision_shape.shape.height = size.y
	elif collision_shape.shape is RectangleShape2D:
		collision_shape.shape.size = size
