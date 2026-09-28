extends StaticBody2D

signal disappear
signal appear

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not $shake.is_stopped():
		var magnitude = 1 - ($shake.time_left / $shake.wait_time)
		var random = RandomNumberGenerator.new()
		$sprite.position.x = random.randf() * magnitude * 4
		$sprite.position.y = random.randf() * magnitude * 3

func _on_player_detect_body_entered(body: Node2D) -> void:
	$shake.start()
	$sprite.modulate.a = 0.7

#func _on_player_detect_body_exited(body: Node2D) -> void:
	#$shake.stop()
	#$sprite.modulate.a = 1


func _on_shake_timeout() -> void:
	$collision.disabled = true
	$sprite.visible = false
	$sprite.modulate.a = 1
	$sprite.position = Vector2.ZERO
	$area/collision.disabled = true
	
	$disappear.start()
	
	disappear.emit()

func _on_disappear_timeout() -> void:
	$collision.disabled = false
	$sprite.visible = true
	$sprite.modulate.a = 1
	$area/collision.disabled = false
	
	appear.emit()
