function scr_set_defaults_for_text(){
	lineBreakPos[0, pageNumber] = 999;
	lineBreakNo[pageNumber] = 0;
	lineBreakOffset[pageNumber] = 0;
	txtbSprite[pageNumber] = spr_textbox;
	speakerSprite[pageNumber] = noone;
	speakerSide[pageNumber] = 1;
	snd[pageNumber] = snd_susie;
	sndDelay[pageNumber] = 4;
	
	// variables for every letter
	for (var c = 0; c < 500; c++){
		col1[c, pageNumber] = c_white;
		col2[c, pageNumber] = c_white;
		col3[c, pageNumber] = c_white;
		col4[c, pageNumber] = c_white;
		
		floatText[c, pageNumber] = false;
		floatDir[c, pageNumber] = c*20;
		
		shakeText[c, pageNumber] = false;
		shakeDir[c, pageNumber]= irandom(360);
		shakeTimer[c, pageNumber] = irandom(4); 
		
	}
	floatIntense = 1;
}


// text vfx
///@param 1st_char
///@param last_char
///@param col1
///@param col2
///@param col3
///@param col4
function scr_text_color(_start, _end, _one, _two, _three, _four){
	for (var c = _start; c <= _end; c++){
		col1[c, pageNumber-1] = _one;
		col2[c, pageNumber-1] = _two;
		col3[c, pageNumber-1] = _three;
		col4[c, pageNumber-1] = _four;
	}
	
}

///@param 1st_char
///@param last_char
///@param intensity
function scr_text_float(_start, _end, _intense){
	floatIntense = _intense;
	for (var c = _start; c <= _end; c++){
		floatText[c, pageNumber-1] = true;
	}
}

///@param 1st_char
///@param last_char
function scr_text_shake(_start, _end){
	for (var c = _start; c <= _end; c++){
		shakeText[c, pageNumber-1] = true;
	}
}

///@param text
///@param [character]
function scr_text(_text){
	scr_set_defaults_for_text();
	text[pageNumber] = _text;
	
	// get char info
	if (argument_count > 1){
		switch(argument[1]){
			
			case "Susie":
				speakerSprite[pageNumber] = spr_susie_default;
				break;
			case "SusieHappy":
				speakerSprite[pageNumber] = spr_susie_happy;
				break;
		}
	}
	
	
	pageNumber++;
	
}

/// @pram option
/// @pram link_id
function scr_option(_option, _link_id){
	option[optionNumber] = _option;
	optionLinkID[optionNumber] = _link_id;
	
	optionNumber++;
}

/// @param text_id
function create_textbox(_text_id){
	with (instance_create_depth(0, 0, -999, obj_textbox)){
		game_text(_text_id);
	}
}