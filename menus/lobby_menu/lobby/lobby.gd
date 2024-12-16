extends HSplitContainer

class_name LobbyUi

@onready var name_label = $Name
@onready var join_button = $Join

var id: int = 0

func _ready():
	join_button.pressed.connect(join)

func init(name: String, id: int):
	self.name_label.text = name
	self.id = id

func join():
	Lobby.join(id)
