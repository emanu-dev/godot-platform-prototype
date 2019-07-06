extends KinematicBody2D

var health = 50
var oldHealth = health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func inflictDamage(player):
	player.receiveDamage(25)
	pass

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
		
		print("current", health)
	else:
		$Sprite/AnimationPlayer.play("SkeletonIdle")
	
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "SkeletonHit":
		oldHealth = health
	
	if anim_name == "SkeletonDead":	
		get_parent().remove_child(self)

	pass 
