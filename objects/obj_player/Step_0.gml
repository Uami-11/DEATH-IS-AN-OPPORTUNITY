keyboard_input();



script_execute(state)


if !place_meeting(x, y, obj_wall_phasable){	
	if keyBubble and bubbled {
		bubbled = false;
	}
}

if bubbled {
	state = player_state_bubble;
	startX = x;
} else {
	hurtTimer = 30;
	state = player_state_free;
}

show_debug_message(bubbled)