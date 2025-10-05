keyboard_input()

if keyUp and timer < 0{
	keyboard_clear(vk_space);
	room_goto(rm_main);
}

timer--