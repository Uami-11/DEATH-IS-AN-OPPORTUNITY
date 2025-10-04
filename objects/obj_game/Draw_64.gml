
draw_set_font(fnt_main_font);
draw_set_color(c_white);
draw_text_transformed(10,10,get_formatted_time(), 3, 3, 0);

show_debug_message(get_formatted_time())