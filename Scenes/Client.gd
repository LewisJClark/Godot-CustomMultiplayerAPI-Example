extends Node

# These signals are for general networking bits that
# you may be interested in.
signal connected_to_server();
signal failed_to_connect();
signal server_disconnected();

# These signals are for the chat program specifically.
signal message_received(user, message);
signal user_left(user_name);
signal user_joined(user_name);

var peer;
var server_port = 1313;

var info = {};

func _ready():
	custom_multiplayer = MultiplayerAPI.new();
	custom_multiplayer.set_root_node(self);
	custom_multiplayer.connect("connected_to_server", self, "_on_connect_succeed");
	custom_multiplayer.connect("connection_failed", self, "_on_connect_fail");
	custom_multiplayer.connect("server_disconnected", self, "_on_server_disconnect");
	
	
func _process(delta):
	if not custom_multiplayer.has_network_peer():
		return;
	# When using custom_multiplayer we HAVE to poll for new
	# network events otherwise nothing will happen!
	custom_multiplayer.poll();

func start(ip, user_info):
	peer = NetworkedMultiplayerENet.new();
	peer.create_client(ip, server_port);
	self.custom_multiplayer.network_peer = peer;
	info = user_info;
	
func _on_connect_succeed():
	emit_signal("connected_to_server");
	rpc_id(1, "set_user_info", info);

func _on_connect_fail():
	emit_signal("failed_to_connect")
	
func _on_server_disconnect():
	emit_signal("server_disconnected")
	
func send_message(message):
	rpc_id(1, "send_message", message);
	

# Functions below are called remotely by the server.
remote func receive_message(user, message):
	emit_signal("message_received", user, message);
	
remote func user_joined(user_name):
	emit_signal("user_joined", user_name);
	
remote func user_left(user_name):
	emit_signal("user_left", user_name);
