extends Node

signal start(file: String)

func _process(delta):
	if Lobby.id != 0:
		read()
		
func read():
	var size = Steam.getAvailableP2PPacketSize(0)
	
	if size <= 0: return
	var p = Steam.readP2PPacket(size, 0)
	
	var sender = p['steam_id_remote']
	var bytes = p['data']
	var data = bytes_to_var(bytes)
	
	match data['type']:
		"start": start.emit("res://levels/test/test.tscn")

func send(target: int, data: Dictionary, type: int):
	var d: PackedByteArray
	d.append_array(var_to_bytes(data))
	
	if target == 0:
		for member in Lobby.members:
			Steam.sendP2PPacket(member['id'], d, type)
	else:
		Steam.sendP2PPacket(target, d, type)
