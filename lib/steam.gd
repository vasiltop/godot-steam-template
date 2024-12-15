extends Node

var id: int

func _ready():
	var res: Dictionary = Steam.steamInit(true, 480, true)
	id = Steam.getSteamID()
	
	if res['status'] > 0:
		print("Failed to initialize Steam")
