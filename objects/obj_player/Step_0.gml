keyboard_input();



script_execute(state)


	
if keyBubble {
	bubbled = !bubbled;
}

if bubbled {
	state = player_state_bubble;
	startX = x;
} else {
	state = player_state_free;
}

show_debug_message(bubbled)