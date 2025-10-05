var keyConfirm = keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_space);
var keyCancel = keyboard_check_pressed(ord("X")) || keyboard_check_pressed(vk_shift);

textboxX = camera_get_view_x(view_camera[0]);
textboxY = camera_get_view_y(view_camera[0]) + 20;

// Delta time setup
var dt = delta_time / 1000000; // Convert microseconds to seconds
var multiplier = dt * 60; // Scale for 60 FPS

// Setup
if (!setup) {
    setup = true;
    draw_set_font(fnt_main_font);
    draw_set_valign(fa_top);
    draw_set_halign(fa_left);
    
    // Loop through the pages
    for (var i = 0; i < pageNumber; i++) {
        // Find how many characters are in each page of text  
        textLength[i] = string_length(text[i]);
        
        portraitXOffset[i] = 53;
        textXOffset[i] = 53; // Get the x position for the text box
        
        // Setting individual characters and finding where line should break
        for (var c = 0; c < textLength[i]; c++) {
            var charPos = c + 1;
            char[c, i] = string_char_at(text[i], charPos);
            
            // Get current width of line
            var _textUpToChar = string_copy(text[i], 1, charPos);
            var _currentTextWidth = string_width(_textUpToChar) - string_width(char[c, i]);
            
            // Get last free space
            if char[c, i] == " " {
                lastFreeSpace = charPos + 1;
            }
            
            // Get the line breaks 
            if (_currentTextWidth - lineBreakOffset[i] > lineWidth * 0.6) {
                lineBreakPos[lineBreakNo[i], i] = lastFreeSpace;
                lineBreakNo[i]++;
                var _textUpToLastSpace = string_copy(text[i], 1, lastFreeSpace);
                var _lastFreeSpaceString = string_char_at(text[i], lastFreeSpace);
                lineBreakOffset[i] = string_width(_textUpToLastSpace) - string_width(_lastFreeSpaceString);
            }
        }
        
        // Getting each character's coordinates
        for (var c = 0; c < textLength[i]; c++) {
            var _charPos = c + 1;
            var _textY = textboxY + border;
            var _textX = textboxX + textXOffset[i] + border;
            var _textUpToChar = string_copy(text[i], 1, _charPos);
            var _currentTextWidth = string_width(_textUpToChar) - string_width(char[c, i]);
            var _textLine = 0;

            // Compensate for string breaks
            for (var lb = 0; lb < lineBreakNo[i]; lb++) {
                // If current looping character is after a line break
                if (_charPos >= lineBreakPos[lb, i]) {
                    var _strCopy = string_copy(text[i], lineBreakPos[lb, i], _charPos - lineBreakPos[lb, i]);
                    _currentTextWidth = string_width(_strCopy);
                    // Record the line this character should be on
                    _textLine = lb + 1; // +1 since lb starts at 0
                }
            }

            // Add to the x and y coordinates 
            charX[c, i] = _textX + _currentTextWidth * 1.5;
            charY[c, i] = _textY + _textLine * lineSeperation;
        }
    }
}

// Drawing the text
if (textPauseTimer <= 0) {
    if (drawChar < textLength[page]) {
        drawChar += textSpeed * multiplier; // Scale text reveal speed
        drawChar = clamp(drawChar, 0, textLength[page]);
        var _checkChar = string_char_at(text[page], floor(drawChar));
        if (_checkChar == "." || _checkChar == "?" || _checkChar == "!") {
            textPauseTimer = textPauseTime;
            if (!audio_is_playing(snd[page])) {
                audio_play_sound(snd[page], 8, false);
            }
        } else if (_checkChar == "," || _checkChar == ";") {
            textPauseTimer = textPauseTime / 2;
            if (!audio_is_playing(snd[page])) {
                audio_play_sound(snd[page], 8, false);
            }
        } else {
            if (sndCount < sndDelay[page]) {
                sndCount += multiplier; // Scale sound counter
            } else {
                sndCount = 0;
                audio_play_sound(snd[page], 8, false);
            }
        }
    }
} else {
    textPauseTimer -= multiplier; // Scale pause timer
}

// Flip through pages
if (keyConfirm) {
    // If typing is done, we can go to next page
    if (floor(drawChar) >= textLength[page]) {
        // Next page
        if (page < pageNumber - 1) {
            page++;
            drawChar = 0;
        } else {
            // Link text if options
            if (optionNumber > 0) {
                create_textbox(optionLinkID[optionPos]);
            }
            // Destroy the textbox
            instance_destroy();
        }
    }
} else if (keyCancel && floor(drawChar) != textLength[page]) {
    drawChar = textLength[page];
}

// Draw the textbox
var _textbX = textboxX + textXOffset[page];
var _textbY = textboxY;

txtbImage += txtbImageSpeed * multiplier; // Scale textbox animation speed
txtbSpriteWidth = sprite_get_width(txtbSprite[0]);
txtbSpriteHeight = sprite_get_height(txtbSprite[0]);

// Draw the speaker
if (speakerSprite[page] != noone) {
    sprite_index = speakerSprite[page];
    if (floor(drawChar) == textLength[page]) {
        image_index = 0;
    }
    var _speakerX = portraitXOffset[page];
    var _speakerY = 151;
    if (speakerSide[page] == -1) {
        _speakerX += sprite_width;
    }
    draw_sprite_ext(txtbSprite[page], txtbImage, _speakerX, _speakerY, 4, 4, 0, c_white, 1);
    draw_sprite_ext(sprite_index, image_index, _speakerX + 12, _speakerY + 8, speakerSide[page] * 1.25, 1.25, 0, c_white, 1);
}

// Draw back of textbox
draw_sprite_ext(txtbSprite[0], txtbImage, _textbX, _textbY, textboxWidth / txtbSpriteWidth, textboxHeight / txtbSpriteHeight, 0, c_white, 1);

// Options
if (floor(drawChar) == textLength[page] && page == pageNumber - 1) {
    // Options selection
    optionPos += keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
    optionPos = clamp(optionPos, 0, optionNumber - 1);
    
    // Drawing the options
    var _opSpace = 20;
    var _opBord = 4;
    for (var op = 0; op < optionNumber; op++) {
        // Box 
        var _opWidth = string_width(option[op]) + _opBord * 2;
        draw_sprite_ext(txtbSprite[1], txtbImage, _textbX + textboxWidth - (_opWidth), _textbY - _opSpace * optionNumber + _opSpace * op - 5, _opWidth / txtbSpriteWidth, (_opSpace - 1) / txtbSpriteHeight, 0, c_white, 1);
        
        // The arrow
        if (optionPos == op) {
            draw_sprite(spr_arrow, image_index, _textbX + textboxWidth - _opWidth - 30, _textbY - _opSpace * optionNumber + _opSpace * op);
        }
        
        // Option text
        draw_text(_textbX + textboxWidth - (_opWidth) + _opBord, _textbY - 5 - _opSpace * optionNumber + _opSpace * op + 2, option[op]);
    }
}

// Draw text
for (var c = 0; c < floor(drawChar); c++) {
    // ----------- Special stuff -----------
    // Float
    var _floatY = 0;
    if (floatText[c, page]) {
        floatDir[c, page] -= 6 * multiplier; // Scale float animation
        _floatY = dsin(floatDir[c, page]) * floatIntense;
    }
    
    // Shake
    var _shakeX = 0;
    var _shakeY = 0;
    if (shakeText[c, page]) {
        shakeTimer[c, page] -= multiplier; // Scale shake timer
        if (shakeTimer[c, page] <= 0) {
            shakeTimer[c, page] = irandom_range(4, 8);
            shakeDir[c, page] += irandom(360);
        } 
        _shakeX = lengthdir_x(1, shakeDir[c, page]);
        _shakeY = lengthdir_y(1, shakeDir[c, page]);
    }

    // The text
    draw_text_transformed_color(charX[c, page] + _shakeX, charY[c, page] + _shakeY + _floatY, char[c, page], 1.5, 1.5, 0, col1[c, page], col2[c, page], col3[c, page], col4[c, page], 1);
}