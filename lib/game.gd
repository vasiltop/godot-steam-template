extends Node

func _ready():
	Packet.switch_level.connect(switch_level)
	
func switch_level(level: String):
	get_tree().change_scene_to_file(level)
