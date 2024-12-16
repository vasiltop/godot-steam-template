extends Node

signal lobby_refresh
signal member_refresh

var id: int = 0
var lobbies: Array = []
var members: Array = []
var temp_name: String = ""

func _ready():
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.join_requested.connect(_on_lobby_join_requested)
	join_from_args()

func join_from_args():
	var args = OS.get_cmdline_args()
	
	if args.size() <= 0: return
	if args[0] != "+connect_lobby": return
	
	var id_to_join = int(args[1])
	join(id_to_join)
	
func create(lobby_type, max_players):
	if id != 0:
		return
		
	Steam.createLobby(lobby_type, max_players)

func _on_lobby_created(connect: int, lobby_id: int):
	if connect != 1: return

	id = lobby_id
	Steam.setLobbyJoinable(id, true)
	Steam.setLobbyData(lobby_id, "name", temp_name)
	Steam.setLobbyData(lobby_id, "mode", "TODO")
	Steam.allowP2PPacketRelay(true)
	refreshLobbyList()

func refreshLobbyList(name: String = ""):
	
	#Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	if name != "":
		Steam.addRequestLobbyListStringFilter("name", name, Steam.LOBBY_COMPARISON_EQUAL)
	Steam.requestLobbyList()

func _on_lobby_match_list(lobbies: Array):
	self.lobbies = lobbies
	lobby_refresh.emit()

func leave():
	Steam.leaveLobby(id)
	id = 0
	update_lobby_members()
	member_refresh.emit()

func join(lobby_id: int):
	Steam.joinLobby(lobby_id)

func _on_lobby_joined(lobby_id: int, permissions: int, locked: bool, response: int):
	if response != Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS: return
	
	id = lobby_id
	update_lobby_members()
	member_refresh.emit()

func _on_lobby_join_requested(lobby_id: int, friend_id: int) -> void:
	join(lobby_id)

func update_lobby_members():
	members.clear()
	var n = Steam.getNumLobbyMembers(id)
	
	for i in range(n):
		var m_id = Steam.getLobbyMemberByIndex(id, i)
		var name = Steam.getFriendPersonaName(m_id)
		members.append({"id": m_id, "name": name})
