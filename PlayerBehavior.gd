extends KinematicBody2D

#OnreadyConst
onready var animPlayer = get_node("Sprite/playerAnimator")
onready var attackArea = get_node("AttackArea/AttackCollision")

#Const
const UP = Vector2(0, -1)
const GRAVITY = 16
const SPEED = 192
const JUMP_HEIGHT = -420
const FALL_MULTIPLIER = 1.6
const JUMP_MULTIPLIER = 2.2
const AIR_MOVEMENT = .8
const KNOCKBACK_FORCE = 256

#Movement
var motion = Vector2()
var gravityModifier = 1
var attackAreaPos = null

#Game Variables
var health = 100
var touchEnemy = false

var currentAnimation = ""

func _ready():
	attackAreaPos = attackArea.position	

func _process(delta):
	animPlayer.play(currentAnimation)


################ PUBLIC FUNCTIONS #######################
func apply_gravity():
	motion.y += GRAVITY * gravityModifier	

func handle_jump():
	if is_on_floor():
		gravityModifier = 1
		
		if Input.is_action_just_pressed("ui_select"):
			motion.y = JUMP_HEIGHT		
	else:
		# Multiply fall speed for a better jump
		if motion.y > 0:		
			gravityModifier = FALL_MULTIPLIER
		# Multiply jump speed for a pressure sensitive jump
		elif motion.y < 0 && !Input.is_action_pressed("ui_select"):		
			gravityModifier = JUMP_MULTIPLIER
			
func handle_move():
	if is_on_floor():
		motion.x = SPEED * _input_horizontal()
	else:
		motion.x = (SPEED * AIR_MOVEMENT) * _input_horizontal()

func apply_motion():
	motion = move_and_slide(motion, UP)	

func flip_sprite():
	#Flip sprite according to direction
	if motion.x < 0:
		$Sprite.flip_h = true 
		attackArea.position.x = attackAreaPos.x *-1
	elif motion.x > 0:
		$Sprite.flip_h = false
		attackArea.position.x = attackAreaPos.x

func damage_by_enemy(body):
	if body.has_method("_inflict_damage"):
		_reset_gravity_modifier()
		_set_damage(body._inflict_damage())
		_dmg_knock_back(body.position)
		_set_damage_box_disabled(true)
		apply_motion()

func play_anim(anim):
	animPlayer.play(anim)

################ PRIVATE FUNCTIONS #######################
func _reset_gravity_modifier():
	gravityModifier = 1

func _set_damage(dmg):
	if !touchEnemy:
		if health - dmg >= 0:
			health -= dmg
		else:
			health -= 0
		
		touchEnemy = true
	else:
		return null
	
func _dmg_knock_back(enemyPosition):
	#move(Vector2(0,-1).rotated(get_global_pos().angle_to_point(enemyPosition))*speed*delta)
	_zero_motion()
	
	motion.x = (SPEED/2) * sign(position.x - enemyPosition.x)
	
	if sign(position.y - enemyPosition.y) >= 0:
		motion.y = KNOCKBACK_FORCE
	elif sign(position.y - enemyPosition.y) < 0:
		motion.y = -KNOCKBACK_FORCE

func _set_damage_box_disabled(disabled):
	get_node("DamageArea/DamageBox").disabled = disabled

func _input_horizontal():
	return int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
func _zero_motion():
	motion = Vector2(0 ,0)
	apply_motion()