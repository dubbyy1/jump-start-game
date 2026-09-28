extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -340.0
const BOUNCE_VELOCITY = -500.0

var bounce = false

var alive = true
signal dead
signal finish

var sun = false

func _physics_process(delta: float) -> void:
	if alive:
		if is_on_floor():
			$coyote.start()
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if bounce:
			velocity.y = BOUNCE_VELOCITY
			bounce = false
		elif Input.is_action_just_pressed("ui_accept") and not $coyote.is_stopped():
			velocity.y = JUMP_VELOCITY
		
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			$sprite.play("default")
			velocity.x = direction * SPEED
			$sprite.flip_h = bool(sign(direction + 1))
		else:
			$sprite.stop()
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if not $sun_timer.is_stopped():
			var c = 1 - ((1 - ($sun_timer.time_left / $sun_timer.wait_time)) * 0.5)
			self.modulate = Color(1, c, c)
		
		move_and_slide()
	
	if has_node("remote_transform"):
		if Input.is_action_pressed("ui_down"):
			$remote_transform.position.y = 36
		else:
			$remote_transform.position.y = -40

func die():
	alive = false
	dead.emit()
	
	var dir = Vector2.ZERO.direction_to(velocity)
	$particles.process_material.direction = Vector3(dir.x, dir.y, 0)
	$particles.process_material.initial_velocity[1] = Vector2.ZERO.distance_to(velocity) * 0.8
	print($particles.process_material.get("initial_velocity"))
	
	$sprite.visible = false
	$particles.emitting = true

func _on_kill_area_entered(area: Area2D) -> void:
	die()

func _on_finish_area_entered(area: Area2D) -> void:
	finish.emit()

func _on_spring_area_entered(area: Area2D) -> void:
	bounce = true


func _on_shadow_area_entered(area: Area2D) -> void:
	$sun_timer.stop()
	self.modulate = Color(1, 1, 1)
func _on_shadow_area_exited(area: Area2D) -> void:
	if sun:
		$sun_timer.start()

func _on_sun_timer_timeout() -> void:
	die()
