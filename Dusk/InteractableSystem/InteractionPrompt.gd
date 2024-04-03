extends Node3D

@onready
var animation_player = $AnimationPlayer

var prompt_showing : bool

func show_prompt():
	if (prompt_showing):
		return
	
	animation_player.play("show_prompt")
	prompt_showing = true

func hide_prompt():
	animation_player.play("hide_prompt")
	prompt_showing = false
