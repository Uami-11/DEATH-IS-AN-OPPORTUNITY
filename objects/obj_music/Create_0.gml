sound = snd_crashing_out
audio_sound_loop_start(sound, 00);
audio_sound_loop_end(sound, 32);

if instance_exists(obj_music_main) instance_destroy(obj_music_main)