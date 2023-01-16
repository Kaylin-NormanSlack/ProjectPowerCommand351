extends KinematicBody

signal pause_button

onready var camera = $Camera;

const MOUSE_SENSITIVITY = 0.0025
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

enum MoveDirection { UP, DOWN, LEFT, RIGHT, NONE }
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity = Vector3.ZERO
var rotating: bool = false

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#camera.current = synchronizer.is_multiplayer_authority()
	pass

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("right", "left", "down", "up")
	var direction = (transform.basis * Vector3(input_dir.x, input_dir.y,0)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide(velocity,Vector3.UP)
	
	#var direction = MoveDirection.NONE
#	if is_network_master():
#		if Input.is_action_pressed('left'):
#			direction = MoveDirection.LEFT
#		elif Input.is_action_pressed('right'):
#			direction = MoveDirection.RIGHT
#		elif Input.is_action_pressed('up'):
#			direction = MoveDirection.UP
#		elif Input.is_action_pressed('down'):
#			direction = MoveDirection.DOWN
#
#
#		rset_unreliable('slave_position', position)
#		rset('slave_movement', direction)
#		_move(direction)
#	else:
#		_move(slave_movement)
#		position = slave_position
#
#	if get_tree().is_network_server():
#		Network.update_position(int(name), position)
#	_move(delta)


#func _move(delta):
#	if not is_on_floor():
#		velocity.y -= gravity * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var input_dir = Input.get_vector("right", "left", "down", "up")
#	var direction = (transform.basis * Vector3(input_dir.x, input_dir.y,0)).normalized()
#	if direction:
#		velocity.x = direction.x * SPEED
#		velocity.z = direction.z * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity.z = move_toward(velocity.z, 0, SPEED)
#
#	move_and_slide(velocity,Vector3.UP)

func _on_pause_button_pressed():
	pass

func _unhandled_input(event):
	if event.is_action_pressed("rotate_camera"):
		rotating = true
	elif event.is_action_released("rotate_camera"):
		rotating = false
	elif event is InputEventMouseMotion and rotating:
		rotate_y(-(event as InputEventMouseMotion).relative.x * MOUSE_SENSITIVITY)

#func init(nickname, start_position, is_slave):
#	global_position = start_position

func _on_join_pressed():
	pass # Replace with function body.
