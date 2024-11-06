extends Node

const PORT := 2024
#const DEFAULT_SERVER_IP := "192.168.0.1"
#const MAX_CONNECTIONS := 6

var peer: Object
var ip_address := ""
#var peer = ENetMultiplayerPeer.new()
var players: Dictionary = {}

func _ready() -> void:
	pass

func InitializeNetwork() -> void:
	peer = ENetMultiplayerPeer.new()

func KillNetwork() -> void:
	multiplayer.multiplayer_peer = null
	peer = null

func HostMultiplayer() -> void:
	#var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer

func JoinMultiplayer(address: String) -> void:
	peer.create_client(address, PORT)
	multiplayer.multiplayer_peer = peer

func GetIP() -> void:
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168."):
			ip_address = ip
