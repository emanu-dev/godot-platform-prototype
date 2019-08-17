extends StateMachine

onready var enemySignals =  get_parent().get_node("Signals")
var motion = Vector2()
var distance = 255

func _ready():
	add_state("idle")
	add_state("react")
	add_state("walk")
	add_state("attack")
	add_state("hit")
	add_state("die")
	call_deferred("set_state", states.idle)	

func _state_logic(delta):
	# print(state)
	motion.x = 0
	#Move this to parent
	if [states.idle, states.walk].has(state):
		if parent.rayCast.is_colliding():
			distance = parent.rayCast.get_collider().position.x - parent.position.x
			# print ("player in sight at ", distance)
			motion.x = parent.speed * sign(distance)
			motion = parent.move_and_slide(motion, Vector2(0, -1))	

#Transition conditions
func _get_transition(delta):
	match state:
		states.idle:
			if abs(motion.x) > 0:
				return states.walk 
			elif parent.has_received_damage():
				if parent.health > 0:
					return states.hit
				else:
					return states.die
		states.react:
			pass
		states.walk:
			if abs(distance) < 64:
				return states.attack
			if motion.x == 0:
				return states.idle
			elif parent.has_received_damage():
				if parent.health > 0:
					return states.hit
				else:
					return states.die				
			pass
		states.attack:
			if parent.has_finished_attack():
				return states.idle
			elif parent.has_received_damage():
				if parent.health > 0:
					return states.hit
				else:
					return states.die
		states.hit:
			if !parent.has_received_damage():
				return states.idle
		states.die:
			pass
	
#Enter state conditions (mostly animations)
func _enter_state(new_state, old_state):
	match state:
		states.idle:
			parent.play_anim("SkeletonIdle")
		states.attack:
			parent.attack()
			parent.play_anim("SkeletonAttack")
		states.walk:
			parent.play_anim("SkeletonWalk")
		states.hit:
			parent.play_anim("SkeletonHit")
		states.die:
			parent.play_anim("SkeletonDead")
			parent.die()
	
func _exit_state(old_state, new_state):
	match state:
		states.idle:
			pass
		states.react:
			pass
		states.walk:
			pass
		states.attack:
			pass
		states.hit:
			pass
		states.die:
			pass
