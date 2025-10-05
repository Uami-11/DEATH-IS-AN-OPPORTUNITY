depth = -999

if (quitting) {
    draw_set_font(fnt_main_font);
    if (quitTimer < 2) {draw_set_color(c_gray)}
    else {draw_set_color(c_white);}
    draw_text_transformed(680, 10, "Quitting...", 6, 6, 0);
}