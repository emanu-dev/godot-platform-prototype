extends Character
signal player_dead

#OnreadyConst
onready var attackArea = get_node("AttackArea/AttackCollision")

#Const
const SPEED = 192
const JUMP_HEIGHT = -420
const FALL_MULTIPLIER = 1.6
const JUMP_MULTIPLIER = 2.2
const AIR_MOVEMENT = .8
const KNOCKBACK_FORCE = 256

#Movement
var attackAreaPos = null

#Game Variables
var touchEnemy = false

func _ready():
	set_animator(get_node("Sprite/playerAnimator"))
	attackAreaPos = attackArea.position	

func _process(delta):
	#print(health)
	
	if Input.is_action_just_pressed("ui_up"):
		touchEnemy = true
		_dmg_knock_back(0)
	
	if health <= 0:
		emit_signal("player_dead")	

################ PUBLIC FUNCTIONS #######################

func handle_jump():
	if is_on_floor():
		set_gravity_modifier(1)
		
		if Input.is_action_just_pressed("jump"):
			motion.y = JUMP_HEIGHT		
	else:
		# Multiply fall speed for a better jump
		if motion.y > 0:		
			set_gravity_modifier(FALL_MULTIPLIER)
		# Multiply jump speed for a pressure sensitive jump
		elif motion.y < 0 && !Input.is_action_pressed("jump"):		
			set_gravity_modifier(JUMP_MULTIPLIER)
			
func handle_move():
	if is_on_floor():
		motion.x = SPEED * _input_horizontal()
	else:
		motion.x = (SPEED * AIR_MOVEMENT) * _input_horizontal()

func flip_sprite():
	if _input_horizontal() != 0:
		set_direction(_input_horizontal())
	pass

func damage_by_enemy(body):
	if body.has_method("_inflict_damage"):
		set_gravity_modifier(1)
		_set_damage(body._inflict_damage())
		_dmg_knock_back(body.position)
		_set_damage_box_disabled(true)

func began_attack():
	return Input.is_action_pressed("attack")
	
func duck():
	return Input.is_action_pressed("ui_down")

func stand_up():
	return Input.is_action_just_released("ui_down")	


################ PRIVATE FUNCTIONS #######################
func _set_damage(dmg):
	if !touchEnemy:
		if health - dmg >= 0:
			health -= dmg
		else:
			health -= 0
		touchEnemy = true
	
func _dmg_knock_back(enemyPosition):
	motion = Vector2(-140, -100)

func _set_damage_box_disabled(disabled):
	get_node("DamageArea/DamageBox").disabled = disabled

func _input_horizontal():
	#print("listens to input")
	return int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
func _zero_motion():
	motion = Vector2(0 ,0)