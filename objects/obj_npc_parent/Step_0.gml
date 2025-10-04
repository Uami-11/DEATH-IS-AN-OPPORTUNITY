if (instance_exists(obj_textbox)) exit;

if (instance_exists(obj_player) and distance_to_object(obj_player) < 8){
	can_talk = true;

}
else {
	can_talk = false
}