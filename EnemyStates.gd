extends StateMachine

onready var enemySignals =  get_parent().get_node("Signals")

func _ready():
	add_state("idle")
	add_state("react")
	add_state("walk")
	add_state("attack")
	add_state("hit")
	add_state("die")
	call_deferred("set_state", states.idle)	

func _state_logic(delta):
	print(state)
	pass

#Transition conditions
func _get_transition(delta):
	match state:
		states.idle:
			if parent.has_received_damage():
				if parent.health > 0:
					return states.hit
				else:
					return states.die
		states.react:
			pass
		states.walk:
			pass
		states.attack:
			pass
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
			parent.play_anim("SkeletonAttack")
		states.hit:
			parent.play_anim("SkeletonHit")
		states.die:
			parent.play_anim("SkeletonDead")
	
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
