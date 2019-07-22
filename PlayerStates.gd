extends StateMachine

var animFinished = false
onready var animPlayer = get_parent().get_node("Sprite/playerAnimator")

func _ready():
	add_state("idle")
	add_state("idleOffense")
	add_state("duck")
	add_state("walk")
	add_state("jump")
	add_state("fall")
	add_state("attack")
	add_state("hurt")
	add_state("special")
	call_deferred("set_state", states.idle)	

func _state_logic(delta):
	#print (animFinished)
	parent._apply_gravity()
	
	if [states.idle, states.idleOffense, states.jump, states.walk, states.fall, states.hurt].has(state):
		parent._apply_movement()		
		
		if state == states.hurt:
			if parent.is_on_floor():
				parent.motion.x = 0
			else:
				parent.motion.x = (parent.SPEED/2) * sign(parent.position.x - parent.enemyPos.x)
	
	if [states.idle, states.idleOffense, states.jump, states.walk, states.fall, states.duck].has(state):
		parent._handle_move_input()
		parent._flip_sprite(parent.motion, parent.attackPos)
	
	#print (state)

#Transition conditions
func _get_transition(delta):
	match state:
		states.idle, states.walk:
			if parent.beingHurt == true:
				return states.hurt			
			if !parent.is_on_floor(): #Player is on the floor
				if parent.motion.y < 0:
					return states.jump
				if parent.motion.y >= 0:
					return states.fall					
			else: #Player is airborne
				if Input.is_action_pressed("ui_accept"):
					return states.attack
				elif Input.is_action_pressed("ui_down"):
					return states.duck					
				elif parent.motion.x != 0:
					return states.walk
				elif parent.motion.x == 0:
					return states.idle
		states.idleOffense:
			if parent.beingHurt == true:
				return states.hurt				
			if !parent.is_on_floor():
				if parent.motion.y < 0:
					return states.jump
				if parent.motion.y >= 0:
					return states.fall					
			else:
				if Input.is_action_pressed("ui_accept"):
					return states.attack
				elif Input.is_action_pressed("ui_down"):
					return states.duck					
				elif parent.motion.x != 0:
					return states.walk
				elif parent.motion.x == 0:
					return states.idleOffense
											
		states.jump:
			if parent.beingHurt == true:
				return states.hurt				
			if parent.is_on_floor():
				return states.idle			
			if parent.motion.y >= 0:
				return states.fall
		states.fall:
			if parent.beingHurt == true:
				return states.hurt				
			if parent.is_on_floor():
				return states.idle
			if parent.motion.y < 0:
				return states.jump				
		states.duck:
			if parent.beingHurt == true:
				return states.hurt				
			if Input.is_action_just_released("ui_down"):
				return states.idle
		states.attack:
			if parent.beingHurt == true:
				return states.hurt				
			if animFinished == true:
				animFinished = false
				return states.idleOffense
		states.hurt:
			if animFinished == true:
				animFinished = false
				parent.beingHurt = false;
				return states.idle				
	return null
	
#Enter state conditions (mostly animations)
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.currentAnimation = "Idle"
		states.walk:
			parent.currentAnimation = "Run"
		states.jump:
			parent.currentAnimation = "Jump"
		states.fall:
			parent.currentAnimation = "Fall"
		states.duck:
			parent.currentAnimation = "Duck"
		states.attack:
			parent.currentAnimation = "Attack"
		states.idleOffense:
			parent.currentAnimation = "IdleOffense"
		states.hurt:
			parent.currentAnimation = "Hurt"
			get_parent().get_node("DamageArea/DamageBox").disabled = true
			# Maybe get this out of here?:
			if sign(parent.position.y - parent.enemyPos.y) > 0:
				parent.motion.y = 386
			else:
				parent.motion.y = -386			
	pass
	
func _exit_state(old_state, new_state):
	match old_state:
		states.hurt:
			get_parent().get_node("DamageArea/DamageBox").disabled = false

func _on_anim_finished(anim_name):
	animFinished = true

func _on_DamageArea(body):
	body = body.get_parent()
	if body.has_method("_inflict_damage"):
		parent.enemyPos = body.position
		parent.beingHurt = true;

func _on_Timer_timeout():
	pass # Replace with function body.
