extends GridContainer

@onready var lobby_list = $Results/ScrollContainer/LobbyList
@onready var member_list = $Lobby/MemberList
@onready var search_name_input = $Search/Name
@onready var create_name_input = $Create/Name
@onready var create_max_players_input = $Create/MaxPlayers
@onready var create_button = $Create/Button
@onready var create_type_input = $Create/Type
@onready var leave_lobby_button = $Lobby/Leave
@onready var lobby_title = $Lobby/Title
@onready var start_game_button = $Lobby/Start

const LOBBY = preload("res://menus/lobby_menu/lobby/lobby.tscn")
const MEMBER = preload("res://menus/lobby_menu/member/member.tscn")

func _ready():
	start_game_button.pressed.connect(start_game)
	search_name_input.text_changed.connect(update_search)
	create_button.pressed.connect(create_lobby)
	leave_lobby_button.pressed.connect(Lobby.leave)
	Lobby.lobby_refresh.connect(update_lobbies)
	Lobby.member_refresh.connect(update_members)
	Lobby.refreshLobbyList()
	create_type_input.select(0)

func create_lobby():
	var type = Steam.LOBBY_TYPE_PUBLIC
	Lobby.temp_name = create_name_input.text
	match create_type_input.get_selected_items()[0]:
		1:
			type = Steam.LOBBY_TYPE_FRIENDS_ONLY
		2:
			type = Steam.LOBBY_TYPE_PRIVATE
	
	Lobby.create(type, int(create_max_players_input.text))

func update_search(text: String):
	Lobby.refreshLobbyList(text)

func update_lobbies():
	GlobalNode.destroy_children(lobby_list)
	
	for lobby in Lobby.lobbies:
		var name = Steam.getLobbyData(lobby, "name")
		if name == "": continue
		
		var inst = LOBBY.instantiate()
		lobby_list.add_child(inst)
		inst.init(name, lobby)

func update_members():
	start_game_button.visible = Lobby.is_leader()
	var name = Steam.getLobbyData(Lobby.id, "name")
	if name == "": name = "None"
	lobby_title.text = "Lobby: " + name
	GlobalNode.destroy_children(member_list)
	
	for member in Lobby.members:
		var inst = MEMBER.instantiate()
		member_list.add_child(inst)
		var n = Steam.getFriendPersonaName(member["id"])
		inst.get_node("Name").text = n

func start_game():
	Packet.send(0, {
		"type": "start"
	}, Steam.P2P_SEND_RELIABLE)
