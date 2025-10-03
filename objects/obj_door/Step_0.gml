
if (place_meeting(x, y, obj_player) and obj_player.keyUp){
	obj_player.locked = true;
	transition_start(roomTarget, sqSlideOutDiagonal, sqSlideInDiagonal)
}