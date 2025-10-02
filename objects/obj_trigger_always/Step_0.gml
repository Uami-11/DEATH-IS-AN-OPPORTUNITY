if !instance_exists(obj_cutscene){
	if (place_meeting(x, y, obj_player)){
		show_debug_message("WAAA")
		create_cutscene(t_scene_info);
	}
}