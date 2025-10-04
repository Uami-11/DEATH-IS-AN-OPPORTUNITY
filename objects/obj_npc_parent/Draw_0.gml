draw_self()

if (can_talk and !instance_exists(obj_textbox)){
	draw_sprite(spr_talk, 0, x, y - 16);
}
