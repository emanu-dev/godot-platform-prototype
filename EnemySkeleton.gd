extends KinematicBody2D

onready var animPlayer = get_node("Sprite/AnimationPlayer")

var currentAnimation = null
var health = 50
var oldHealth = health
var receivedDamage = false

func has_received_damage():
	return receivedDamage

func set_received_damage(hasDamage):
	receivedDamage = hasDamage

func _inflict_damage():
	return 25

func set_damage(dmg):
	health -= dmg
	receivedDamage = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func die():
	$CollisionBox.disabled = true;
	$HitArea/HitBox.disabled = true;
	get_parent().remove_child(self)
	
func play_anim(anim):
	animPlayer.play(anim)