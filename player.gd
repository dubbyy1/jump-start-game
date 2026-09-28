extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -340.0
const BOUNCE_VELOCITY = -500.0

var bounce = false

signal dead
signal finish

var sun = false

func _physics_process(delta: float) -> void:
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
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if not $sun_timer.is_stopped():
		var c = 1 - ((1 - ($sun_timer.time_left / $sun_timer.wait_time)) * 0.5)
		self.modulate = Color(1, c, c)
	
	if Input.is_action_pressed("ui_down"):
		$remote_transform.position.y = 36
	else:
		$remote_transform.position.y = -40
	
	move_and_slide()

func die():
	dead.emit()
	queue_free()

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
