
if (place_meeting(x, y, obj_player) and obj_player.keyUp) and !instance_exists(obj_textbox){
	create_textbox(textID);
}