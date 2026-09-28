extends Node2D

@export var sun = false

@export var next_level = 1
@onready var NextLevel = load("res://levels/level_" + str(next_level) + ".tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sun:
		$player.sun = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()


func _on_player_dead() -> void:
	$death_timer.start()

func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()

func _on_player_finish() -> void:
	get_tree().change_scene_to_packed(NextLevel)
