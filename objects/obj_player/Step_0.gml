keyboard_input();



script_execute(state)




if bubbled {
	state = player_state_bubble;
	startX = x;
} else {
	hurtTimer = 30;
	state = player_state_free;
}

show_debug_message(bubbled)