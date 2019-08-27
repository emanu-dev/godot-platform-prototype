extends KinematicBody2D
class_name Character

var animator = null setget set_animator

const UP = Vector2(0, -1)
const GRAVITY = 16
const DIRECTION_RIGHT = 1
const DIRECTION_LEFT = -1

var motion = Vector2()
var direction = Vector2(DIRECTION_RIGHT, 1)
var gravityModifier = 1 setget set_gravity_modifier, get_gravity_modifier
var health = 100

var enemyTouchedPosition = Vector2() setget set_enemy_touched_position, get_enemy_touched_position

func set_direction(hor_direction):
    if hor_direction == 0:
        hor_direction = DIRECTION_RIGHT # default to right if param is 0
    var hor_dir_mod = hor_direction / abs(hor_direction) # get unit direction
    apply_scale(Vector2(hor_dir_mod * direction.x, 1)) # flip
    direction = Vector2(hor_dir_mod, direction.y) # update direction

func set_animator(node):
	animator = node

func set_gravity_modifier(newvalue):
	gravityModifier = newvalue
	
func get_gravity_modifier():
	return gravityModifier

func apply_gravity():
	motion.y += GRAVITY * gravityModifier

func apply_motion():
	motion = move_and_slide(motion, UP)

func set_motion(m):
	motion = m
	apply_motion()

func play_anim(animName):
	animator.play(animName)

func set_enemy_touched_position(p):
	enemyTouchedPosition = p

func get_enemy_touched_position():
	return enemyTouchedPosition
	
func attack():
	pass
	
func die():
	pass
