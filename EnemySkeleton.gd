extends KinematicBody2D

onready var animPlayer = get_node("Sprite/AnimationPlayer")
onready var enemySignals =  get_node("Signals")
onready var rayCast =  get_node("RayCast2D")

var health = 50
var speed = 96
var oldHealth = health
var receivedDamage = false
var finishedAttack = false

func _process(delta):
	pass

func die():
	$CollisionBox.disabled = true;
	$HitArea/HitBox.disabled = true;
	get_parent().remove_child(self)
	
func play_anim(anim):
	animPlayer.play(anim)
	
func attack():
	finishedAttack = false
	
func finish_attack():
	finishedAttack = true
	
func has_finished_attack():
	return finishedAttack

func has_received_damage():
	return receivedDamage

func set_received_damage(hasDamage):
	receivedDamage = hasDamage

func set_damage(dmg):
	health -= dmg
	receivedDamage = true

func _inflict_damage():
	return 25