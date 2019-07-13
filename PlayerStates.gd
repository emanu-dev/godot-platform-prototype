extends StateMachine

var animFinished = false

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
	print (animFinished)
	parent._handle_move_input()
	parent._apply_gravity()
	if [states.idle, states.idleOffense, states.jump, states.walk, states.fall].has(state):
		parent._apply_movement()
	
	if state == states.duck:
		parent.currentAnimation = "Duck"
	
	#print (state)

	
func _get_transition(delta):
	match state:
		states.idle, states.walk:
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
					return states.idle
					
		states.idleOffense:
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
			if parent.is_on_floor():
				return states.idle			
			if parent.motion.y >= 0:
				return states.fall
		states.fall:
			if parent.is_on_floor():
				return states.idle
			if parent.motion.y < 0:
				return states.jump				
		states.duck:
			if Input.is_action_just_released("ui_down"):
				return states.idle
		states.attack:
			if animFinished == true:
				animFinished = false
				return states.idleOffense
				
	return null
	
	
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
	pass
	
func _exit_state(old_state, new_state):
	pass

func _on_anim_finished(anim_name):
	animFinished = true

func _on_DamageArea(area):
	pass # Replace with function body.
