
if (instance_exists(obj_player) and distance_to_object(obj_player) < 7){
	canInteract = true;
}
else {
	canInteract = false
}


if (place_meeting(x, y, obj_player) and obj_player.keyUp){
	obj_player.locked = true;
	transition_start(roomTarget, sqSlideOutDiagonal, sqSlideInDiagonal)
}