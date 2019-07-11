extends StateMachine

func _ready():
	add_state("idle")
	add_state("duck")
	add_state("walk")
	add_state("jump")
	add_state("fall")
	add_state("attack")
	add_state("hurt")
	add_state("special")
	call_deferred("set_state", states.idle)	

func _state_logic(delta):
	parent._handle_move_input()
	parent._apply_gravity()
	if [states.idle, states.jump, states.walk, states.fall].has(state):
		parent._apply_movement()
	
	if state == states.duck:
		parent.currentAnimation = "Duck"
	
	print (state)

	
func _get_transition(delta):
	match state:
		states.idle, states.walk:
			if !parent.is_on_floor():
				if parent.motion.y < 0:
					return states.jump
				if parent.motion.y >= 0:
						return states.fall					
			if Input.is_action_pressed("ui_down"):
				return states.duck
			else:
				if parent.motion.x != 0:
					return states.walk
				if parent.motion.x == 0:
					return states.idle
		states.jump:
			if parent.motion.y >= 0:
					return states.fall
		states.fall:
			if parent.motion.y == 0:
					return states.idle
		states.duck:
			if Input.is_action_just_released("ui_down"):
				return states.idle
	
func _enter_state(new_state, old_state):
	match state:
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
	pass
	
func _exit_state(old_state, new_state):
	pass