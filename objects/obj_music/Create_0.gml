sound = snd_crashing_out
audio_sound_loop_start(snd_crashing_out, 00);
audio_sound_loop_end(snd_crashing_out, 32);

if instance_exists(obj_music_main) instance_destroy(obj_music_main)