extends Node

signal user_connected();
signal user_disconnected();
signal server_started();

var peer;
var max_clients = 32;
var server_port = 1313;

var users = {};

func _ready():
	custom_multiplayer = MultiplayerAPI.new();
	custom_multiplayer.set_root_node(self);
	custom_multiplayer.connect("network_peer_connected", self, "_on_user_connect");
	custom_multiplayer.connect("network_peer_disconnected", self, "_on_user_disconnect");
	

func _process(delta):
	if not custom_multiplayer.has_network_peer():
		return;
	# When using custom_multiplayer we HAVE to poll for new
	# network events otherwise nothing will happen!
	custom_multiplayer.poll();


func start():
	peer = NetworkedMultiplayerENet.new();
	peer.create_server(server_port, max_clients);
	
	if (peer == null):
		# Should probably handle this somehow.
		return;
	
	self.custom_multiplayer.network_peer = peer;
	emit_signal("server_started");
	
	
func _on_user_connect(id):
	pass
	
func _on_user_disconnect(id):
	if users.has(id):
		emit_signal("user_disconnected", users[id].name);
		rpc("user_left", users[id].name);
		users.erase(id);
	else:
		emit_signal("user_disconnected", "User");
		rpc("user_left", "User");
	
	
# Called remotely by a client once they have connected.
# They can set arbitrary information about themselves and it gets stored
# on the server until they disconnect.
#
# For this example the only information they send is the name they want
# to use in the chatroom.
remote func set_user_info(user_info):
	var id = custom_multiplayer.get_rpc_sender_id();
	users[id] = user_info;
	
	emit_signal("user_connected", user_info);
	
# Called remotely by any client who wants to send a message.
remote func send_message(message):
	var id = custom_multiplayer.get_rpc_sender_id();
	var user = users[id].name;
	
	rpc("receive_message", user, message);
		 
