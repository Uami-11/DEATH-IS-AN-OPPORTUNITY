if room != rm_minus && room != rm_victory && !instance_exists(obj_textbox){ global.speedrun_timer += delta_time / 1000000;}

if room = rm_victory{
	instance_destroy()
}

window_set_cursor(cr_none);