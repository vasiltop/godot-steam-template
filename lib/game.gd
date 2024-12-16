extends Node

func _ready():
	Packet.start.connect(start)
	
func start(level: String):
	get_tree().change_scene_to_file(level)
