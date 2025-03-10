extends CharacterBody2D
@onready var player: AnimatedSprite2D = $AnimatedSprite2D
@onready var coinlabel: Label = $Viewport/Label
@onready var audioplayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var speed: int = 200
@export var jump_velocity: int = -450
@export var health: int = 100
var moving: bool = false
var coin_counter = 0
var coin_sound = preload("res://Audio/CoinSFX.mp3")
var sprinting: bool

### Animations, Functions ###
#Idle
func idle_animation():
	player.play("idle")
	#Normal Speed
	speed = 100

#Walking
func walking_animation():
	#Movement Checker
	if moving == true:
		player.play("walking")
		#Normal Speed
		speed = 100
		#Movement Checker
		if Input.is_action_pressed("ui_left"):
			player.flip_h = true
		elif Input.is_action_pressed("ui_right"):
			player.flip_h = false
	elif moving == false:
		player.play("idle")

#Running
func running_animation():
	#Movement Checker
	if moving == true:
		player.play("running")
		#Sprinting Speed
		speed = 170
		#Movement Checker
		if Input.is_action_pressed("ui_left"):
			player.flip_h = true
		elif Input.is_action_pressed("ui_right"):
			player.flip_h = false
	elif moving == false:
		player.play("idle")

#Jumping
func jumping_animation():
	player.play("jumping")
	if Input.is_action_pressed("ui_left"):
		player.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		player.flip_h = false

#Dying
func dying_animation():
	#Nullified Speed
	speed = 0
	player.play("dying")
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_scene()
	
func _process(delta: float) -> void:
	if health <= 0:
		dying_animation()
	else:
		pass
	if Input.is_action_pressed("ui_accept"):
		jumping_animation()
	elif Input.is_action_pressed("Sprint"):
		sprinting = true
		running_animation()
	elif Input.is_action_pressed("ui_left"):
		walking_animation()
	elif Input.is_action_pressed("ui_right"):
		walking_animation()
	else:
		idle_animation()


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		moving = true
	elif Input.is_action_pressed("ui_right"):
		moving = true
	else:
		moving = false
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Coin"):
		coin_counter += 1
		coinlabel.text = "Score: " + str(coin_counter)
		audioplayer.stream = coin_sound
		audioplayer.play()
