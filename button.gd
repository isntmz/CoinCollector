extends Button

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		if self.visible == false:
			self.visible = true
		elif self.visible == true:
			self.visible = false
