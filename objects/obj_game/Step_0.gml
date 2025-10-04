if room != rm_minus && room != rm_victory{ global.speedrun_timer += delta_time / 1000000;}

if room = rm_victory{
	instance_destroy()
}