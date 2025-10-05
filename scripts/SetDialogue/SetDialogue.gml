/// @param text_id

function game_text(_text_id){
	
	switch(_text_id){
		case "expo":
			if global.remember.exposition == 0 {
				scr_text("The Fox! Thank goodness.");
				scr_text("Glad you could make it on such short notice.");
				scr_text("But right now we are infront of the most evil scheme ever concieved!");
				scr_text("This is a saw making factory!");
				scr_text("Or so they want us to think! We have just received intel that they are creating saws that turn you into bubbles!");
				scr_text("The CEO, Arctic, wants to turn everyone into bubbles and rule the world!");
				scr_text("The Fox... We need you to carefully platform your way through the factory and turn this operation off.");
				scr_text("There will be many saws it there, and that would mean death in any other case.");
				scr_text("But in this one... It might be an opportunity to weave through the many traps in there!");
				scr_text("Goodluck The Fox, we believe in you!");
				
				global.remember.exposition++;
			} else {
				scr_text("Once you turn this factory off, we can live peacefully without any bubble turning saws.");
			}
			break;
		
		case "wind":
			scr_text("Ahhhh, The Fox");
			scr_text("Arctic expected you to come.");
			scr_text("That's why she tasked me to put some roadblocks to stop anyone from getting any further!")
			scr_text("Let's just say it will blow you away, muhahahah!");
			break;
		
		case "eat":
			scr_text("The Fox... I am immpressed you have made it this far.");
			scr_text("You have used the opporunities given by these \"death\" bubbles quite well.");
			scr_text("But I knew when we made these bubbles, that they would be a powerful tool for people able to burst through it.");
			scr_text("So I made bubble eating mice!!!");
			scr_text("If they eat you, then you will...");
			scr_text("Be magically transported to the beginning");
			break;
		
		case "bb":
			scr_text("I used to be a factory worker, now I am a bubble ghost.");
			scr_text("But life's good, all things considered.");
			scr_text("On the other side of the room is Ducky. He is a duck. I think he is a developer of some sorts.");
			scr_text("He is pretty cool.");
			if global.remember.duckTalk > 0 {
				scr_text("What? His name is Eagly? But he is a duck. Gotta be Ducky.");
			}
			global.remember.blindTalk++
			break;
			
		case "antibb":
			scr_text("That guy over there thinks I am a duck. I'm an eagle. And my name is Eagly?");
			scr_text("I think he has bird blindness.");
			global.remember.duckTalk++;
			break;
		
		case "Final":
			scr_text("Fox...");
			scr_text("So, you've made it the the final floor.");
			scr_text("You might think I made this factory to take over the world.");
			scr_text("But no. I made it to kill you!");
			scr_text("Why?")
			scr_text("Isn't it obvious? Look at me! I am a big strong fox!");
			scr_text("But what do they call you?");
			scr_text("THE Fox! You're not THE anything! Ever since you came along, us foxes have been relegated to being like you!");
			scr_text("Well no more! After you die in this floor, I'm taking the name back to the people! Screw you! I hate you.");
			
			break;
		
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