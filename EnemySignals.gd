extends Node

onready var parent = get_parent()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "SkeletonHit":
		parent.set_received_damage(false)
	
	if anim_name == "SkeletonDead":	
		parent.die()
	
	if anim_name == "SkeletonAttack":	
		parent.finish_attack()
