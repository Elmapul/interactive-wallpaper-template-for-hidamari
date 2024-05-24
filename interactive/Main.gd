extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if(OS.has_feature("server")):
		get_tree().change_scene("res://server.tscn")
		#get_window().title = "server" 
		
	if(OS.has_feature("client")):
		get_tree().change_scene("res://client.tscn")
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_client_pressed():
	get_tree().change_scene("res://client.tscn")
	pass # Replace with function body.


func _on_server_pressed():
	get_tree().change_scene("res://server.tscn")
	pass # Replace with function body.
