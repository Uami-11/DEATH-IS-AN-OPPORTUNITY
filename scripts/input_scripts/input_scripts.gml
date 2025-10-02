function keyboard_input(){
	keyUp = keyboard_check(vk_up) || keyboard_check(ord("W"));
	keyDown = keyboard_check(vk_down) || keyboard_check(ord("S"));
	keyRight = keyboard_check(vk_right) || keyboard_check(ord("D"));
	keyLeft = keyboard_check(vk_left) || keyboard_check(ord("A"));
	keyJump = keyboard_check(vk_space) ;
	keyJumpPressed = keyboard_check_pressed(vk_space);
	keyBurst = keyboard_check(ord("R"));
	keyBubble = keyboard_check_pressed(ord("O")) || keyboard_check_pressed(vk_space);
	

}