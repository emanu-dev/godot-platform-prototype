extends KinematicBody2D
class_name Character

var animator = null setget set_animator

const UP = Vector2(0, -1)
const GRAVITY = 16

var motion = Vector2()
var gravityModifier = 1 setget set_gravity_modifier, get_gravity_modifier
var health = 100


func set_animator(node):
	animator = node

func set_gravity_modifier(newvalue):
	gravityModifier = newvalue
	
func get_gravity_modifier():
	return gravityModifier

func apply_motion():
	motion = move_and_slide(motion, UP)

func apply_gravity():
	motion.y += GRAVITY * gravityModifier

func play_anim(animName):
	animator.play(animName)
	
func attack():
	pass
	
func die():
	pass
