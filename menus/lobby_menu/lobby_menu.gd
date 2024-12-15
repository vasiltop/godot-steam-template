extends GridContainer

@onready var lobby_list = $Results/ScrollContainer/LobbyList
@onready var member_list = $Lobby/MemberList/List

const LOBBY = preload("res://menus/lobby_menu/lobby/lobby.tscn")

func _ready():
	Lobby.lobby_refresh.connect(update_lobbies)
	Lobby.refreshLobbyList()

func update_lobbies():
	GlobalNode.destroy_children(lobby_list)
	
	for lobby in Lobby.lobbies:
		var inst = LOBBY.instantiate()
		lobby_list.add_child(inst)
