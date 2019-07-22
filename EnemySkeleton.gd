extends KinematicBody2D

var health = 50
var oldHealth = health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _inflict_damage():
	return 25

func receiveDamage(dmg):
	health -= dmg
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if oldHealth > health:
		if health > 0:
			$Sprite/AnimationPlayer.play("SkeletonHit")
		else:
			$Sprite/AnimationPlayer.play("SkeletonDead")
			$CollisionBox.disabled = true;
			$HitArea/HitBox.disabled = true;
		
		#print("current", health)
	else:
		$Sprite/AnimationPlayer.play("SkeletonIdle")
	
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "SkeletonHit":
		oldHealth = health
	
	if anim_name == "SkeletonDead":	
		get_parent().remove_child(self)

	pass 
