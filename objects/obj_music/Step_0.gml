if !audio_is_playing(sound){
	if sound != snd_victory{
		audio_play_sound(sound, 10, 1);
	} else {
		audio_play_sound(sound, 10, 1);
	}
}


if room == rm_level_six_1 && sound != snd_final_level{
	audio_stop_all()
	sound = snd_final_level
}

if room == rm_victory && sound != snd_victory{
	audio_stop_all()
	sound = snd_victory
}

if room == rm_main{audio_stop_all(); instance_destroy()}

