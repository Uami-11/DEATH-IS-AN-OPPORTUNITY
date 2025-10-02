/// @param text_id

function game_text(_text_id){
	
	switch(_text_id){
		case "Ball":
			global.npcInteractions++;
			scr_text("My full name? Susie Gaster.", "Susie")
				scr_text_color(14, 25, c_red, c_red, c_red, c_red) 
			scr_text("Yo}, I meant to end this. sentence but i messed. up lowk", "Susie");
				scr_text_color(0, 1,  c_yellow, c_yellow, c_yellow, c_yellow)
			scr_text("Baller");
			scr_text("I gotta ask, stall or call?", "Susie");
			scr_text_shake(13, 26)
				scr_option("Stall for sure", "Ball - Stall");
				scr_option("Definitely call", "Ball - Call");
			break;
			case "Ball - Stall":
				if global.npcInteractions > 1 {
					scr_text("I respect that", "SusieHappy");
				} else {
					scr_text("Dont know if i believe you yet", "SusieHappy");
				}
				break;
			case "Ball - Call":
				scr_text("I hate you lowk");
				break;	
		case "Stall":
			scr_text("A B C D E F G H I J K L M N O P Q R S T U V W X Y Z");
			scr_text("I am testing things out now. I might be... G. A. Y. Gay!!!!", "Susie");
				scr_text_float(0, 18, 2)
				scr_text_float(52, 58, 2)
			break;
		case "movie":
			scr_text("Me doing this alone isn't fixing anything!");
				scr_text_float(33, 44, 2);
			scr_text("I think I know what to do");
			scr_text("We need to change our fates together!");
			break;
	}
}