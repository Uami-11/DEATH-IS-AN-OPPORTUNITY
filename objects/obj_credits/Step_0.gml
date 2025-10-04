keyboard_input()

if keyRight
{
	image_index = 1;
}

if keyLeft {
	image_index = 0;
}

if keyJump and image_index == 1{
	room_goto(rm_credits)
}