extends Character
signal player_dead

#OnreadyConst
onready var attackArea = get_node("AttackArea/AttackCollision")
onready var timer = get_node("Timer")
onready var sprite = get_node("Sprite")

#Const
const SPEED = 192
const JUMP_HEIGHT = -600
const FALL_MULTIPLIER = 1.6
const JUMP_MULTIPLIER = 2.2
const AIR_MOVEMENT = 1
const KNOCKBACK_FORCE = 256

#Movement
var attackAreaPos = null

#Game Variables
var touchEnemy = false
var timeInvincible = 2
var invincibleCount = 0

func _ready():
	set_animator(get_node("Sprite/playerAnimator"))
	attackAreaPos = attackArea.position	

func _process(delta):
	#print(health)
	#print(get_node("DamageArea/DamageBox").disabled)
	#print(touchEnemy)
	
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

func dmg_knock_back():
	var tempPos = self.global_position - get_enemy_touched_position()
	tempPos = Vector2(sign(tempPos.x), sign(tempPos.y)) * -1
	motion = tempPos * JUMP_HEIGHT/2.5

func damage_by_enemy(body):
	set_gravity_modifier(1)
	_set_damage(body.inflict_damage())

func began_attack():
	return Input.is_action_pressed("attack")

func toggle_invincibility():
	if timer.is_stopped():
		timer.start(0.05)
		_set_damage_box_disabled(true)
	else:
		if invincibleCount < timeInvincible:
			if sprite.visible:
				sprite.visible = false
			else: 
				sprite.visible = true
			invincibleCount += timer.wait_time
		else:
			_set_damage_box_disabled(false)
			invincibleCount = 0
			timer.stop()		
		
func duck():
	return Input.is_action_pressed("ui_down")

func stand_up():
	return Input.is_action_just_released("ui_down")	

################ PRIVATE FUNCTIONS #######################
func _set_damage(dmg):
	if health - dmg >= 0:
		health -= dmg
	else:
		health -= 0

func _set_damage_box_disabled(disabled):
	get_node("DamageArea/DamageBox").disabled = disabled

func _input_horizontal():
	return int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
func _zero_motion():
	motion = Vector2(0 ,0)