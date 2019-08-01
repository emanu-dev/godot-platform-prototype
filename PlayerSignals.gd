extends Node

onready var parent = get_parent()
var animFinished = false

func _on_DamageArea_area_entered(body):
	var b = body.get_parent()
	parent.damage_by_enemy(b)

func _on_AttackArea_body_entered(body):
	if body.has_method("receiveDamage"):
		body.receiveDamage(10)

func _on_playerAnimator_animation_finished(anim_name):
	animFinished = true

func _on_playerAnimator_animation_started(anim_name):
	#animFinished = false
	pass
