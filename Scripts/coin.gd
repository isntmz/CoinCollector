extends CharacterBody2D

func _process(_delta: float) -> void:
	$AnimatedSprite2D.play("default")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		position = Vector2(randi_range(20, 1136),randi_range(20, 628))
