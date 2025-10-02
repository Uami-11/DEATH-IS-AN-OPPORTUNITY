keyboard_input();



script_execute(state)


	
if keyBubble and bubbled {
	bubbled = false;
}

if bubbled {
	state = player_state_bubble;
	startX = x;
} else {
	hurtTimer = 60;
	state = player_state_free;
}

show_debug_message(bubbled)