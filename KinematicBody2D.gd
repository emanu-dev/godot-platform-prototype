extends KinematicBody2D

#Animations
onready var animPlayer = get_node("Sprite/playerAnimator")

#Const
const UP = Vector2(0, -1)
const GRAVITY = 16
const SPEED = 192
const JUMP_HEIGHT = -480
const FALL_MULTIPLIER = 1.6
const JUMP_MULTIPLIER = 2.2
const AIR_MOVEMENT = .8

#Movement
var motion = Vector2()

var currentAnimation = ""

var beingHurt = false

var attackLvl = 0
var attackPos = Vector2()

#Game Variables
var health = 100

#Create
func _ready():
	attackPos = $Sprite/AttackArea/AttackCollision.position
	pass

#Update Every Step
func _process(delta):
	if is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			inputAttack()

	animPlayer.play(currentAnimation)

	pass

#Process Physics
func _physics_process(delta):	

	pass

################ CUSTOM FUNCS #######################

func _handle_move_input():
	if is_on_floor():
		motion.x = SPEED * inputHorizontal()
		if Input.is_action_just_pressed("ui_select"):
			motion.y = JUMP_HEIGHT	
	else:
		motion.x = (SPEED * AIR_MOVEMENT) * inputHorizontal()


func _apply_movement():
	motion = move_and_slide(motion, UP)	

func _apply_gravity():
		# Multiply fall speed for a better jump
		if motion.y > 0:		
			motion.y += GRAVITY * FALL_MULTIPLIER
		# Multiply jump speed for a pressure sensitive jump
		elif motion.y < 0 && !Input.is_action_pressed("ui_select"):		
			motion.y += GRAVITY * JUMP_MULTIPLIER
		# Regular gravity
		else:
			motion.y += GRAVITY	

func _flip_sprite(motion, attackPos):
	#Flip sprite according to direction
	if motion.x < 0:
		$Sprite.flip_h = true 
	elif motion.x > 0:
		$Sprite.flip_h = false

	if sign(motion.x) != 0:
		$Sprite/AttackArea/AttackCollision.position.x = attackPos.x * sign(motion.x)
	
	pass

func receiveDamage(area, dmg):
	health -= dmg
	$Sprite.flip_h = $Sprite.flip_h
	var enemyPos = area.get_parent().position
	motion.x += sign(self.position.x - enemyPos.x) * 300
	motion.y += sign(self.position.y - enemyPos.y) * 150
	motion = move_and_slide(motion, UP)	
	pass

func inputHorizontal():
	return int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	pass
	
func inputAttack():
	attackLvl += 1
	#print (attackLvl)
	pass	

func _on_AttackArea_body_entered(body):
	if body.has_method("receiveDamage"):
		body.receiveDamage(10)
	pass 


func _on_DamageArea_area_entered(area):
	pass # Replace with function body.
