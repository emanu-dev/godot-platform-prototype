extends StateMachine

onready var playerSignals =  get_parent().get_node("Signals")

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
	#print (playerSignals.animFinished)
	
	if [states.idle, states.idleOffense, states.jump, states.walk, states.fall].has(state):
		parent.handle_jump()
		parent.apply_gravity()
		parent.apply_motion()	
		
	if state == states.hurt:
		print(parent.motion)
		parent.apply_gravity()
		print(parent.motion)
		parent.apply_motion()
	
	if [states.idle, states.idleOffense, states.jump, states.walk, states.fall, states.duck].has(state):
		parent.handle_move()
		parent.flip_sprite()
	
	# print (state)

#Transition conditions
func _get_transition(delta):
	match state:
		states.idle, states.walk:
			if parent.touchEnemy == true:
				return states.hurt			
			if !parent.is_on_floor(): #Player is airborne
				if parent.motion.y < 0:
					return states.jump
				if parent.motion.y >= 0:
					return states.fall					
			else: #Player is on the floor
				if parent.began_attack():
					return states.attack
				elif parent.duck():
					return states.duck					
				elif parent.motion.x != 0:
					return states.walk
				elif parent.motion.x == 0:
					return states.idle
		states.idleOffense:
			if parent.touchEnemy == true:
				return states.hurt				
			if !parent.is_on_floor():
				if parent.motion.y < 0:
					return states.jump
				if parent.motion.y >= 0:
					return states.fall					
			else:
				if parent.began_attack():
					return states.attack
				elif parent.duck():
					return states.duck					
				elif parent.motion.x != 0:
					return states.walk
				elif parent.motion.x == 0:
					return states.idleOffense
											
		states.jump:
			if parent.touchEnemy == true:
				return states.hurt				
			elif parent.is_on_floor():
				return states.idle			
			elif parent.motion.y >= 0:
				return states.fall
		states.fall:
			if parent.touchEnemy == true:
				return states.hurt
			elif parent.is_on_floor():
				return states.idle
			elif parent.motion.y < 0:
				return states.jump
		states.duck:
			if parent.touchEnemy == true:
				return states.hurt				
			if parent.stand_up():
				return states.idle
		states.attack:
			if parent.touchEnemy == true:
				return states.hurt				
			if playerSignals.animFinished == true:
				playerSignals.animFinished = false
				return states.idleOffense
		states.hurt:
			if playerSignals.animFinished == true:
				playerSignals.animFinished = false
				parent.touchEnemy = false;
				return states.idle				
	return null
	
#Enter state conditions (mostly animations)
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.play_anim("Idle")
		states.walk:
			parent.play_anim("Run")
		states.jump:
			parent.play_anim("Jump")
		states.fall:
			parent.play_anim("Fall")
		states.duck:
			parent.play_anim("Duck")
		states.attack:
			parent.play_anim("Attack")
		states.idleOffense:
			parent.play_anim("IdleOffense")
		states.hurt:
			parent._zero_motion()
			parent.play_anim("Hurt")
	pass
	
func _exit_state(old_state, new_state):
	match old_state:
		states.hurt:
			parent._set_damage_box_disabled(false)
