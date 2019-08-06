extends KinematicBody2D

onready var animPlayer = get_node("Sprite/AnimationPlayer")

var health = 50
var oldHealth = health
var receivedDamage = false

func _process(delta):
	pass

func die():
	$CollisionBox.disabled = true;
	$HitArea/HitBox.disabled = true;
	get_parent().remove_child(self)
	
func play_anim(anim):
	animPlayer.play(anim)
	
func has_received_damage():
	return receivedDamage

func set_received_damage(hasDamage):
	receivedDamage = hasDamage

func set_damage(dmg):
	health -= dmg
	receivedDamage = true

func _inflict_damage():
	return 25