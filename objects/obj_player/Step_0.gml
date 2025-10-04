keyboard_input();
if !instance_exists(obj_invisi_camera) instance_create_depth(x, y, -999, obj_invisi_camera);


script_execute(state)




if bubbled {
	state = player_state_bubble;
	startX = x;
} else {
	hurtTimer = 30;
	state = player_state_free;
}

show_debug_message(bubbled)

if room = rm_level_six_1 {
	if died = true{
		global.remember.deadFinal++;
	}
}