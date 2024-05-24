extends Node


# The URL we will connect to, 127.0.0.1 means localhost
var websocket_url = "ws://127.0.0.1:8000"
var _client = WebSocketClient.new()

#those are flags, they are ints where each binary digit represent an button from the mouse or gamepad1
var mouse_state=0 #any value above 0 means an button is being clicked
var gamepad1_buttons=0 #any value above 0 means an button is being pressed

# to-do move those to global variables in the future (to avoide code duplication)
var left_click=1	
var right_click=2
var middle_click=4
var scroll_up=8
var scroll_down=16
var scroll_left_bt=32
var scroll_right_bt=64
var mouse_button_8=128
var mouse_button_9=256

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

func _ready():
	OS.set_window_title("Client")
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")
	# Initiate connection to the given URL.
	get_node("Timer").start()


var rotate=0
func _process(_delta):
	pass

func _physics_process(delta):
	_client.poll()
	
	pass	
func 	attempt_connect():

	pass
func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	get_node("Label").text="Closed, clean: "+ str(was_clean)
	#set_process(false) # i'm not sure if this is required, removing it didnt break anything yet
	get_node("Label").text="trying to reconect"
	print("trying to reconnect in 3 seconds")
	get_node("Warning").start()
	
	

func _connected(proto = ""):

	print("Connected with protocol: ", proto)
	get_node("Label").text="Connected with protocol: "+str(proto)
	_client.get_peer(1).put_packet("Test packet".to_utf8())


func _on_data():
	var msg="Got data from server: "
	msg=_client.get_peer(1).get_packet().get_string_from_utf8()
	print("Got data from server: ", msg)
	
	get_node("Label2").text= msg
	var inputReceived=msg.split(",")
	get_node("Icon").position.x=int(inputReceived[0]) #mouse X
	get_node("Icon").position.y=int(inputReceived[1]) #mouse Y
	mouse_state=int(inputReceived[2]) #mouse button mask
	gamepad1_buttons=int(inputReceived[3]) #gamepad 1 button mask
	get_node("Button_mask").text=str(gamepad1_buttons)
	decodeButtons()
	#get_node("Button_mask").text=inputReceived[5] i forgot what i was testing

var result
func decodeButtons():
	#an example on how to decode button presses
	result=gamepad1_buttons & Dpad_up
	if(result>0):
		press("d_pad_up")
	result=gamepad1_buttons & Dpad_down
	if(result>0):
		press("d_pad_down")	
	result=gamepad1_buttons & Dpad_left
	if(result>0):
		press("d_pad_left")
	result=gamepad1_buttons & Dpad_right
	if(result>0):
		press("d_pad_right")
		
		
func press(event):
	var a = InputEventAction.new()
	a.action = event
	a.pressed = true
	Input.parse_input_event(a)
	pass

func _input(event):
	#if(OS.has_feature("hidamari")):
		if event.is_action_pressed("d_pad_up"):
			get_node("KinematicBody2D").move_and_slide(Vector2(0.0,-200.0)) 
		if event.is_action_pressed("d_pad_down"):
			get_node("KinematicBody2D").move_and_slide(Vector2(0.0,200.0)) 
		if event.is_action_pressed("d_pad_right"):
			get_node("KinematicBody2D").move_and_slide(Vector2(200.0,0.0)) 
		if event.is_action_pressed("d_pad_left"):
			get_node("KinematicBody2D").move_and_slide(Vector2(-200.0,0.0)) 

func _exit_tree():
	_client.disconnect_from_host()


func _on_Timer_timeout():
	
	
	#attempt_connect()
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("time out")
		get_node("Label").text="time out fail"
		#get_node("Label").text="trying to reconect"
		#set_process(false) #wtf? that is what is crashing?
		get_node("Warning").start()
	
	pass 


func _on_Warning_timeout():
	print("warning")
	get_node("Label").text="warning  fail"
	get_node("Timer").start()
	pass
