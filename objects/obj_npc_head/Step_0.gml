if (instance_exists(obj_textbox)){
	image_speed = 1;
} else image_speed = 0; image_index = 3;

if (instance_exists(obj_player) and distance_to_object(obj_player) < 8){
	can_talk = true;

}
else {
	can_talk = false
}

if global.remember.deadFinal > 0 {
	if instance_exists(obj_speakbox){
		with (obj_speakbox){
			instance_destroy();
		}
	}
	instance_destroy();
}