extends Control

var user_info = {
	"name": "User"
}

onready var host_btn = $HostButton;
onready var connect_btn = $ConnectButton;
onready var send_btn = $SendButton;

onready var ip_edit = $IpEdit;
onready var name_edit = $NameEdit;
onready var message_edit = $MessageEdit;

onready var chat_log = $ChatLog;

onready var client = get_node("/root/Main/Client");
onready var server = get_node("/root/Main/Server");

func _ready():
	host_btn.connect("pressed", self, "_on_host_btn_press");
	connect_btn.connect("pressed", self, "_on_connect_btn_press");
	send_btn.connect("pressed", self, "_on_send_btn_press");
	message_edit.connect("text_entered", self, "_on_message_entered");
	
	client.connect("connected_to_server", self, "_on_client_connected");
	client.connect("failed_to_connect", self, "_on_client_failed_to_connect");
	client.connect("server_disconnected", self, "_on_client_disconnected");
	client.connect("message_received", self, "_on_client_message_received");
	client.connect("user_left", self, "_on_client_user_left");
	client.connect("user_joined", self, "_on_client_user_joined");
	
	server.connect("server_started", self, "_on_server_started");
	server.connect("user_connected", self, "_on_server_user_connected");
	server.connect("user_disconnected", self, "_on_server_user_disconnected");
	

func _on_host_btn_press():
	server.start();
	
func _on_connect_btn_press():
	user_info["name"] = name_edit.text;
	client.start(ip_edit.text, user_info);	
	
func _on_send_btn_press():
	client.send_message(message_edit.text);
	message_edit.clear();
	
func _on_message_entered(message):
	client.send_message(message_edit.text);
	message_edit.clear();


# Here we handle all signals emitted by the Client node.
# These functions will run in all instances of the program 
# as a client will always be used to connect to the server,
# locally hosted or not.

func _on_client_connected():
	chat_log.add_item("You have connected to the chat.");
	connect_btn.disabled = true;
	send_btn.disabled = false;
	host_btn.disabled = true;
	message_edit.editable = true;
	name_edit.editable = false;	
	ip_edit.editable = false;

func _on_client_failed_to_connect():
	chat_log.add_item("Failed to connect to the chat.");

func _on_client_disconnected():
	chat_log.add_item("You have been disconnected from the chat.");
	connect_btn.disabled = false;
	send_btn.disabled = true;
	host_btn.disabled = false;
	message_edit.editable = false;
	name_edit.editable = true;	
	ip_edit.editable = true;
	
func _on_client_message_received(user, message):
	log_user_message(user, message);

func _on_client_user_left(user):
	chat_log.add_item(user + " has left the chat.")
	
func _on_client_user_joined(user):
	chat_log.add_item(user + " has joined the chat.")
	
# Here we handle all signals emitted by the Server node.
# These functions will only ever run if the user is hosting their
# own server locally as these are bindings to the local server 
# instance.

func _on_server_started():
	log_server_message("Local server up and running.");
	host_btn.disabled = true;

func _on_server_user_connected(user_info):
	log_server_message(user_info.name + " has connected!");

func _on_server_user_disconnected(user_name):
	log_server_message(user_name + " has disconnected.");
	
	
# Utility functions for printing nice-ish looking messages
# to the chat log.

func log_user_message(user, message):
	var complete_msg = "[" + user + "]: " + message;
	chat_log.add_item(complete_msg);
	

func log_server_message(message):
	var complete_msg = "[SERVER]: " + message;
	chat_log.add_item(complete_msg);
	


