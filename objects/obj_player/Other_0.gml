		show_debug_message("HELLO I AM TRYING")
		transition_start(room, sqSlideOutDiagonal, sqSlideInDiagonal)
		if !audio_is_playing(snd_fail){
			audio_play_sound(snd_fail, 9, 0);
		}
		died = true;