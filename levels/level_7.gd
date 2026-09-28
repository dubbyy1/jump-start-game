extends "res://levels/base_level.gd"

func _on_cloud_disappear() -> void:
	$shadow/collision2.disabled = true
	$shadow/occluder2.visible = false

func _on_cloud_appear() -> void:
	$shadow/collision2.disabled = false
	$shadow/occluder2.visible = true
