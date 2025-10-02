var keyConfirm = keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter);
var keyCancel  = keyboard_check_pressed(ord("X")) || keyboard_check_pressed(vk_shift);

textboxX = camera_get_view_x(view_camera[0]);
textboxY = camera_get_view_y(view_camera[0]) + 248;

// setup

if (!setup){
	setup = true;
	draw_set_font(fontText);
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	
	// loop through the pages
	for (var i = 0; i < pageNumber; i++){
		
		// find how many characters are in each page of text  
		textLength[i] = string_length(text[i]);
		
		portraitXOffset[i] = 53;
		
		textXOffset[i] = 53; // get the x position for the text box
		
		
		// setting individual characters and finding where line should break
		for (var c = 0; c < textLength[i]; c++){
			var charPos = c+1;
			char[c, i] = string_char_at(text[i], charPos);
			
			// get current width of line
			var _textUpToChar = string_copy(text[i], 1, charPos);
			var _currentTextWidth = string_width(_textUpToChar) - string_width(char[c, i]);
			
			// get last free space
			if char[c, i] ==  " " {lastFreeSpace = charPos+1};
			
			// get the line breaks 
			if (_currentTextWidth - lineBreakOffset[i] > lineWidth * 0.8){
				lineBreakPos[lineBreakNo[i], i] = lastFreeSpace;
				lineBreakNo[i]++;
				var _textUpToLastSpace = string_copy(text[i], 1, lastFreeSpace);
				var _lastFreeSpaceString = string_char_at(text[i], lastFreeSpace);
				lineBreakOffset[i] = string_width(_textUpToLastSpace) - string_width(_lastFreeSpaceString);
			}

		}
		// getting each characters coordinates
		for (var c = 0; c < textLength[i]; c++){
			var _charPos = c + 1;
			var _textY = textboxY + border;
			var _textX = textboxX + textXOffset[i] + border;
			var _textUpToChar = string_copy(text[i], 1, _charPos);
			var _currentTextWidth = string_width(_textUpToChar) - string_width(char[c, i]);
			var _textLine = 0;

			// compensate for string breaks
			for (var lb = 0; lb < lineBreakNo[i]; lb++){
				// if current looping character is after a line break
				if (_charPos >= lineBreakPos[lb, i]){
					var _strCopy = string_copy(text[i], lineBreakPos[lb, i], _charPos-lineBreakPos[lb, i]);
					_currentTextWidth = string_width(_strCopy);

					// record the line this character should be on
					_textLine = lb + 1; // +1 since lb starts at 0
				}
			}

			// add to the x and y coordinates 
			charX[c, i] = _textX + _currentTextWidth*1.2;
			charY[c, i] = _textY + _textLine*lineSeperation;

		}
	}
		
	
}
if textPauseTimer <=0
{
	// drawing the text
	if (drawChar < textLength[page]){
		drawChar += textSpeed;
		drawChar = clamp(drawChar, 0, textLength[page]);
		var _checkChar = string_char_at(text[page], drawChar);
		if _checkChar == "." || _checkChar == "?" || _checkChar == "!"{
			textPauseTimer = textPauseTime;
			if !audio_is_playing(snd[page]){
			audio_play_sound(snd[page], 8, false);}
		} else if _checkChar == "," || _checkChar == ";"{
			textPauseTimer = textPauseTime / 2;
			if !audio_is_playing(snd[page]) {audio_play_sound(snd[page], 8, false);}
		} 
		{
			if sndCount < sndDelay[page] {
				sndCount++;
			} else {
				sndCount = 0;
				audio_play_sound(snd[page], 8, false);
			}
		}
	}
} else {
	textPauseTimer--;
}

// flip through pages
if (keyConfirm){
	// if typing is done, we can go to next page
	if (drawChar == textLength[page]){
		// next page
		if (page < pageNumber - 1){
			page++;
			drawChar = 0;
		} else{
			// link text if options
			if (optionNumber > 0){
				create_textbox(optionLinkID[optionPos]);
			}
			// destroy the textbox
			instance_destroy();
		}
	}
} else if (keyCancel and drawChar != textLength[page]){
    drawChar = textLength[page];
}




// draw the textbox
var _textbX = textboxX + textXOffset[page];
var _textbY = textboxY;

txtbImage += txtbImageSpeed;
txtbSpriteWidth = sprite_get_width(txtbSprite[0]);
txtbSpriteHeight = sprite_get_height(txtbSprite[0]);

// draw the speaker
if (speakerSprite[page] != noone){
	sprite_index = speakerSprite[page];
	if drawChar == textLength[page] {image_index = 0};
	var _speakerX = portraitXOffset[page];
	var _speakerY = 151;
	if (speakerSide[page] = -1){
		_speakerX += sprite_width;
	}
	draw_sprite_ext(txtbSprite[page], txtbImage, _speakerX, _speakerY, 4, 4, 0, c_white, 1);
	draw_sprite_ext(sprite_index, image_index, _speakerX + 12, _speakerY + 8, speakerSide[page]* 1.25, 1.25, 0, c_white, 1);
}

// draw back of textbox

draw_sprite_ext(txtbSprite[0], txtbImage, _textbX, _textbY, textboxWidth/txtbSpriteWidth, textboxHeight/txtbSpriteHeight, 0, c_white, 1);


// options
if (drawChar == textLength[page] && page == pageNumber - 1){
	
	// options selection
	optionPos += keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
	optionPos = clamp(optionPos, 0, optionNumber - 1);
	
	// Drawing the options
	var _opSpace = 20;
	var _opBord = 4;
	for (var op = 0; op < optionNumber; op++){
		// box 
		var _opWidth = string_width(option[op]) + _opBord*2;
		draw_sprite_ext(txtbSprite[1], txtbImage, _textbX + textboxWidth - (_opWidth), _textbY - _opSpace*optionNumber + _opSpace*op - 5, _opWidth/txtbSpriteWidth, (_opSpace-1)/txtbSpriteHeight, 0, c_white, 1);
		
		
		// the arrow
		if (optionPos == op){
			draw_sprite(spr_arrow, image_index, _textbX + textboxWidth - _opWidth - 30, _textbY - _opSpace*optionNumber + _opSpace*op)
		}
		
		// option text
		draw_text( _textbX + textboxWidth - (_opWidth) + _opBord, _textbY-5  - _opSpace*optionNumber + _opSpace*op +2, option[op]);
	}
}

// draw text
for (var c = 0; c < drawChar; c++){

	// ----------- special stuff -----------
	// floatt
	var _floatY = 0;
	if floatText[c, page]{
		floatDir[c, page] += -6;
		_floatY = dsin(floatDir[c, page]) * floatIntense;
	}
	
	// shake
	_shakeX = 0;
	_shakeY = 0;
	if shakeText[c, page] {
		shakeTimer[c, page]--;
		if shakeTimer[c, page] <= 0 {
			shakeTimer[c, page] = irandom_range(4, 8)
			shakeDir[c, page] += irandom(360);
		} 
		_shakeX = lengthdir_x(1, shakeDir[c, page]);
		_shakeY = lengthdir_y(1, shakeDir[c, page]);
		
		
	}

	// the text
	draw_text_transformed_color(charX[c, page] + _shakeX, charY[c, page] + _shakeY + _floatY, char[c, page], 1.2, 1.2, 0, col1[c, page], col2[c, page], col3[c, page], col4[c, page], 1);
}
