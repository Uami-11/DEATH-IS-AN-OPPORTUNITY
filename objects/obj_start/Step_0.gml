keyboard_input()

if keyLeft
{
	image_index = 1;
}

if keyRight {
	image_index = 0;
}

if keyJump and image_index == 1{
	transition_start(rm_parent, sqSlideOutDiagonal, sqSlideInDiagonal)
}