extends Node3D

@export var tessa_sprite: TessaSprite

func _process(_delta: float) -> void:
	scale.y = 1.0 - tessa_sprite.solve_cos(tessa_sprite.curr_rotation, 0.2, false)
