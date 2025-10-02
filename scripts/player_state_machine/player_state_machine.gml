function player_change_animation(_input, _timer){
		if !bubbled {
			if (ySpeed != 0){
				image_speed = 0;
				sprite_index = spr_player_jump;
				if sign(ySpeed) ==  1{
					image_index = 1;
				} else {
					image_index = 0;
				}
				if (_input > 0){
					image_xscale = 1.5;
				}
				if (_input < 0){
					image_xscale = -1.5;
				}
		
		
			} else {
				image_speed = 1;
				if (_input > 0){
					sprite_index = spr_player_run;
					image_xscale = 1.5;
				}
				if (_input < 0){
					sprite_index = spr_player_run;
					image_xscale = -1.5;
				}
				if _input == 0 {
					sprite_index = spr_player_idle;
				}
			}
		} else {
			
			if _timer > 0 {
				sprite_index = spr_player_hurt;
			} else {
				sprite_index = spr_player_dizzy
			}
			
		}
	
}

function player_state_free(){

    var _move_input = keyRight - keyLeft;   // already in your code
    var _jump_pressed = keyJumpPressed;     // already in your code

    player_physics_step(_move_input, _jump_pressed);
	player_change_animation(_move_input, _jump_pressed);

    show_debug_message("xSpeed: " + string(xSpeed) + " | ySpeed: " + string(ySpeed));


}

function player_state_bubble(){
	
	player_change_animation(0, hurtTimer);
	
	if !place_meeting(x, y-10, obj_wall){
		y -= 1;
	} else {bubbled = false}
	if place_meeting(x, y, obj_fog) {
		x += 5
	} else {
		x += sin(timer*0.03) * 0.5;
	}
	
	
	ySpeed = 0
	hurtTimer--;
	timer++;
	show_debug_message(string_concat("hurtTimer: ", hurtTimer))
}


function player_physics_step(_move_input, _jump_pressed) {
    // === Jump Buffering ===
    if (_jump_pressed) {
        jumpBufferCount = 0;
    }
    if (jumpBufferCount < jumpBuffer) {
        jumpBufferCount++;
    }

    // === Horizontal Movement ===
    if (place_meeting(x, y + 1, obj_wall) || place_meeting(x, y + 1, obj_wall_phasable)) { // On ground
        if _move_input == 0 || (xSpeed * _move_input < 0) {
            xSpeed -= xSpeed * brakeRateGround;
        }
        xSpeed += _move_input * accelRateGround;
    }
    else { // In air
        if _move_input == 0 || (xSpeed * _move_input < 0) {
            xSpeed -= xSpeed * brakeRateAir;
        }
        xSpeed += _move_input * accelRateAir;
    }

    // Clamp speed
    xSpeed = clamp(xSpeed, -runSpeed, runSpeed);

    // === Gravity ===
    if (ySpeed < gravMax) || !(place_meeting(x, y + 1, obj_wall) || place_meeting(x, y + 1, obj_wall_phasable)) {
        ySpeed += gravRate;
    }

    // === Jump (coyote / ledge buffer) ===
    if ((place_meeting(x, y + 1, obj_wall) || place_meeting(x, y+1, obj_wall_phasable)) && jumpBufferCount < jumpBuffer) {
        ySpeed = jumpSpeed;
        jumpBufferCount = jumpBuffer; // consume buffer
    }

    // === Collision resolution ===
	// Horizontal (sides)
	if (place_meeting(x + xSpeed, y, obj_wall) || place_meeting(x + xSpeed, y, obj_wall_phasable)) {
		while (!(place_meeting(x + sign(xSpeed), y, obj_wall) || place_meeting(x + sign(xSpeed), y, obj_wall_phasable))) {
			x += sign(xSpeed);
		}
		xSpeed = 0;
	}

	// Vertical (top/bottom)
	if (place_meeting(x, y + ySpeed, obj_wall) || place_meeting(x, y + ySpeed, obj_wall_phasable)) {
		while (!(place_meeting(x, y + sign(ySpeed), obj_wall) || place_meeting(x, y + sign(ySpeed), obj_wall_phasable))) {
			y += sign(ySpeed);
		}
		ySpeed = 0;
	}
	
	if place_meeting(x, y+ySpeed, obj_spikes){
		bubbled = true;
	}

	// Diagonal
	if (place_meeting(x + xSpeed, y + ySpeed, obj_wall) || place_meeting(x + xSpeed, y + ySpeed, obj_wall_phasable)) {
		while (!(place_meeting(x + sign(xSpeed), y + sign(ySpeed), obj_wall) || place_meeting(x + sign(xSpeed), y + sign(ySpeed), obj_wall_phasable))) {
			x += sign(xSpeed);
			y += sign(ySpeed);
		}
		xSpeed = 0;
		ySpeed = 0;
	}

    // === Apply Movement ===
    x += xSpeed;
    y += ySpeed;
}
