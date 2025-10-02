// textbox parameters
textXOffset = [];
textboxWidth = 532;
textboxHeight = 96;
border = 16;
lineSeperation = 18; // spacing
lineWidth = textboxWidth - border * 2 // how long a line can be
txtbSprite[0] = spr_textbox;
txtbSprite[1] = spr_descisions
txtbImage = 0;
txtbImageSpeed = 0;
fontText = fnt_main_font;

// the text
page = 0;
pageNumber = 0;
text[0] = "";
textLength[0] = string_length(text[0]);
char[0, 0] = "";
charX[0, 0] = 0;
charY[0,0] = 0;
drawChar = 0; // how many characters is being drawn
textSpeed = 1;

// options
option[0] = "";
optionLinkID[0] = -1;
optionPos = 0;
optionNumber = 0;

setup = false; // check if setup has been done

// effects
scr_set_defaults_for_text();
lastFreeSpace = 0;

sndDelay[0] = 4;
sndCount = sndDelay[0];

textPauseTimer = 0;
textPauseTime = 16;