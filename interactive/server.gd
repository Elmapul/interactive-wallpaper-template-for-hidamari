extends Node


# The port we will listen to.
const PORT = 8000
# Our WebSocketServer instance.
var _server = WebSocketServer.new()
var inputStreaming=false
var currentid
#######################

var mouse_state=0 #any value above 0 means an button is being clicked
var left_click=1	
var right_click=2
var middle_click=4
var scroll_up=8
var scroll_down=16
var scroll_left_bt=32
var scroll_right_bt=64
var mouse_button_8=128
var mouse_button_9=256

var gamepad1_buttons=0 #any value above 0 means an button is being pressed
var A=1					#button 0
var B=2					#button 1
var Y=4					#button 2
var X=8					#button 3
var L1=16				#button 4
var R1=32				#button 5
var Select=64			#button 8
var Start=128			#button 9
var L3=256				#button 10
var R3=512				#button 11
var Dpad_up=1024		#button 12
var Dpad_down=2048		#button 13
var Dpad_left=4096		#button 14
var Dpad_right=8192		#button 15
var home=16384			#button 16

var passthrough=false


func _ready():
	OS.set_window_title("Server")
	get_tree().get_root().set_transparent_background(true)
	var pool = PoolVector2Array([Vector2(0,0), Vector2(1,0), Vector2(0,1)])
	OS.set_window_mouse_passthrough(pool)


	# Connect base signals to get notified of new client connections,
	# disconnections, and disconnect requests.
	_server.connect("client_connected", self, "_connected")
	_server.connect("client_disconnected", self, "_disconnected")
	_server.connect("client_close_request", self, "_close_request")
	# This signal is emitted when not using the Multiplayer API every time a
	# full packet is received.
	# Alternatively, you could check get_peer(PEER_ID).get_available_packets()
	# in a loop for each connected peer.
	_server.connect("data_received", self, "_on_data")
	# Start listening on the given port.
	var err = _server.listen(PORT)
	if err != OK:
		print("Unable to start server")
		#set_process(false)


func _connected(id, proto):
	# This is called when a new peer connects, "id" will be the assigned peer id,
	# "proto" will be the selected WebSocket sub-protocol (which is optional)
	print("Client %d connected with protocol: %s" % [id, proto])
	_server.get_peer(id).put_packet("godot".to_utf8())
	currentid=id
	inputStreaming=true


func _close_request(id, code, reason):
	# This is called when a client notifies that it wishes to close the connection,
	# providing a reason string and close code.
	print("Client %d disconnecting with code: %d, reason: %s" % [id, code, reason])


func _disconnected(id, was_clean = false):
	# This is called when a client disconnects, "id" will be the one of the
	# disconnecting client, "was_clean" will tell you if the disconnection
	# was correctly notified by the remote peer before closing the socket.
	print("Client %d disconnected, clean: %s" % [id, str(was_clean)])


func _on_data(id):
	# Print the received packet, you MUST always use get_peer(id).get_packet to receive data,
	# and not get_packet directly when not using the MultiplayerAPI.
	var pkt = _server.get_peer(id).get_packet()
	print("Got data from client %d: %s ... echoing" % [id, pkt.get_string_from_utf8()])
	var teste="it works" #.to_utf8()
	#_server.get_peer(id).put_packet(pkt)
	#_server.get_peer(id).put_packet(teste.to_utf8())
	_server.get_peer(id).put_packet("godot".to_utf8())
	


func _process(_delta):
	
	var pos=get_viewport().get_mouse_position()
	
	if(inputStreaming):
		var message=str(pos.x)+","+str(pos.y)+","+str(mouse_state)+","+str(gamepad1_buttons)
		_server.get_peer(currentid).put_packet(message.to_utf8())
		pass
	_server.poll()


func _exit_tree():
	_server.stop()


func encode_mouse_press(event):
	if event.is_action_pressed("left_click"):
		mouse_state+=left_click
	if event.is_action_pressed("right_click"):
		mouse_state+=right_click
	if event.is_action_pressed("middle_click"):
		mouse_state+=middle_click
	if event.is_action_pressed("scroll_up"):
		mouse_state+=scroll_up
	if event.is_action_pressed("scroll_down"):
		mouse_state+=scroll_down

	if event.is_action_pressed("scroll_left_bt"):
		mouse_state+=scroll_left_bt
	if event.is_action_pressed("scroll_right_bt"):	
		mouse_state+=scroll_right_bt
	if event.is_action_pressed("mouse_button_8"):	
		mouse_state+=mouse_button_8
	if event.is_action_pressed("mouse_button_9"):	
		mouse_state+=mouse_button_9
func encode_mouse_relase(event):
	if event.is_action_released("left_click"):
		mouse_state-=left_click
	if event.is_action_released("right_click"):
		mouse_state-=right_click
	if event.is_action_released("middle_click"):
		mouse_state-=middle_click
	if event.is_action_released("scroll_up"):
		mouse_state-=scroll_up
	if event.is_action_released("scroll_down"):
		mouse_state-=scroll_down
	if event.is_action_released("scroll_left_bt"):
		mouse_state-=scroll_left_bt	
	if event.is_action_released("scroll_right_bt"):	
		mouse_state-=scroll_right_bt	
	if event.is_action_released("mouse_button_8"):	
		mouse_state-=mouse_button_8		
	if event.is_action_released("mouse_button_9"):	
		mouse_state-=mouse_button_9
	
	pass


func encode_gamepad1_pess(event):
	if event.is_action_pressed("xbox_a"):
		gamepad1_buttons+=A
	if event.is_action_pressed("xbox_b"):
		gamepad1_buttons+=B	
	if event.is_action_pressed("xbox_y"):
		gamepad1_buttons+=Y	
	if event.is_action_pressed("xbox_x"):
		gamepad1_buttons+=X	
	if event.is_action_pressed("L1"):
		gamepad1_buttons+=L1
	if event.is_action_pressed("R1"):
		gamepad1_buttons+=R1
	if event.is_action_pressed("L3"):
		gamepad1_buttons+=L3
	if event.is_action_pressed("R3"):
		gamepad1_buttons+=R3
	if event.is_action_pressed("Start"):
		gamepad1_buttons+=Start
	if event.is_action_pressed("Select"):
		gamepad1_buttons+=Select
	if event.is_action_pressed("d_pad_up"):
		gamepad1_buttons+=Dpad_up
	if event.is_action_pressed("d_pad_down"):
		gamepad1_buttons+=Dpad_down
	if event.is_action_pressed("d_pad_left"):
		gamepad1_buttons+=Dpad_left
	if event.is_action_pressed("d_pad_right"):
		gamepad1_buttons+=Dpad_right
func encode_gamepad1_relase(event):
	if event.is_action_released("xbox_a"):
		gamepad1_buttons-=A
	if event.is_action_released("xbox_b"):
		gamepad1_buttons-=B	
	if event.is_action_released("xbox_y"):
		gamepad1_buttons-=Y	
	if event.is_action_released("xbox_x"):
		gamepad1_buttons-=X	
	if event.is_action_released("L1"):
		gamepad1_buttons-=L1
	if event.is_action_released("R1"):
		gamepad1_buttons-=R1
	if event.is_action_released("L3"):
		gamepad1_buttons-=L3
	if event.is_action_released("R3"):
		gamepad1_buttons-=R3
	if event.is_action_released("Start"):
		gamepad1_buttons-=Start
	if event.is_action_released("Select"):
		gamepad1_buttons-=Select
	if event.is_action_released("d_pad_up"):
		gamepad1_buttons-=Dpad_up
	if event.is_action_released("d_pad_down"):
		gamepad1_buttons-=Dpad_down
	if event.is_action_released("d_pad_left"):
		gamepad1_buttons-=Dpad_left
	if event.is_action_released("d_pad_right"):
		gamepad1_buttons-=Dpad_right
func _input(event):
	#gamepad1_buttons=0
	if event.is_action_pressed("passOn"):	
		var pool = PoolVector2Array([Vector2(0,0), Vector2(1,0), Vector2(0,1)])
		OS.set_window_mouse_passthrough(pool)
		pass
	if event.is_action_pressed("passOff"):	
		OS.set_window_mouse_passthrough([])
		pass
		
	if event.is_action_pressed("toggle_passthrough"):	
		if(passthrough==true):
			var pool = PoolVector2Array([Vector2(0,0), Vector2(1,0), Vector2(0,1)])
			OS.set_window_mouse_passthrough(pool)
			passthrough=false
		else:
			OS.set_window_mouse_passthrough([])
			passthrough=true
		
	encode_mouse_press(event)
	encode_mouse_relase(event)
	encode_gamepad1_pess(event)
	encode_gamepad1_relase(event)

