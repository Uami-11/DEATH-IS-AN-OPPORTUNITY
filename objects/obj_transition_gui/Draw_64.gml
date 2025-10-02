if (seq_player != -1) {
    var w = display_get_gui_width();
    var h = display_get_gui_height();
    var cx = w * 0.5;
    var cy = h * 0.5;
    sequence_instance_set_position(seq_player, cx, cy);
}
