function player_change_animation(_input, _timer){
		obj_invisi_camera.x = x;
		obj_invisi_camera.y = y;
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
			image_speed = 1;
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
	if died {
		sprite_index = spr_player_dead
	} else {
		if !locked {
			player_physics_step(_move_input, _jump_pressed);
			player_change_animation(_move_input, _jump_pressed);
			
		} else {
				
			if instance_exists(obj_textbox){
				sprite_index = spr_player_idle
			}
		}
	}

    show_debug_message("xSpeed: " + string(xSpeed) + " | ySpeed: " + string(ySpeed));


}

function player_state_bubble(){
	
	player_change_animation(0, hurtTimer);
	
	if !place_meeting(x, y-10, obj_wall){
		y -= 1;
	} else {bubbled = false; audio_play_sound(snd_popped, 10, 0); }
	var inst = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_fog, false, true);
	if (inst != noone) {
	    x += 5 * inst.dir;
	} else {
		x += sin(timer*0.03) * 0.5;
	}
	if place_meeting(x, y-11, obj_bubble_trap){
		show_debug_message("HELLO I AM TRYING")
		transition_start(room, sqSlideOutDiagonal, sqSlideInDiagonal)
		if !audio_is_playing(snd_fail){
			audio_play_sound(snd_fail, 9, 0);
		}
		died = true;
	}
	if !place_meeting(x, y, obj_wall_phasable) and hurtTimer < 0{	
		if keyBubble {
			bubbled = false;
		}
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
        if (_move_input == 0 || (xSpeed * _move_input < 0)) {
            xSpeed -= xSpeed * brakeRateGround;
        }
        xSpeed += _move_input * accelRateGround;
    } else { // In air
        if (_move_input == 0 || (xSpeed * _move_input < 0)) {
            xSpeed -= xSpeed * brakeRateAir;
        }
        xSpeed += _move_input * accelRateAir;
    }

    // Clamp speed
    xSpeed = clamp(xSpeed, -runSpeed, runSpeed);

    // === Gravity ===
    if (ySpeed < gravMax || !(place_meeting(x, y + 1, obj_wall) || place_meeting(x, y + 1, obj_wall_phasable))) {
        ySpeed += gravRate;
    }

    // === Jump (coyote / ledge buffer) ===
    if ((place_meeting(x, y + 1, obj_wall) || place_meeting(x, y + 1, obj_wall_phasable)) && jumpBufferCount < jumpBuffer) {
        ySpeed = jumpSpeed;
        jumpBufferCount = jumpBuffer; // consume buffer
	    audio_sound_pitch(snd_jump, 0.65);
	    audio_play_sound(snd_jump, 10, 0);
    }

    // === Collision Resolution ===
    // Horizontal (sides)
    if (place_meeting(x + xSpeed, y, obj_wall) || place_meeting(x + xSpeed, y, obj_wall_phasable)) {
        var _step = sign(xSpeed);
        while (abs(xSpeed) > 0 && !(place_meeting(x + _step, y, obj_wall) || place_meeting(x + _step, y, obj_wall_phasable))) {
            x += _step;
            xSpeed -= _step; // Gradually reduce speed to avoid overshooting
        }
        xSpeed = 0;
    }

    

    // Vertical (top/bottom)
    if (place_meeting(x, y + ySpeed, obj_wall) || place_meeting(x, y + ySpeed, obj_wall_phasable)) {
        var _step = sign(ySpeed);
        while (abs(ySpeed) > 0 && !(place_meeting(x, y + _step, obj_wall) || place_meeting(x, y + _step, obj_wall_phasable))) {
            y += _step;
            ySpeed -= _step; // Gradually reduce speed to avoid overshooting
        }
        ySpeed = 0;
    }
	
	// Resolve current overlaps (prioritize shortest escape direction)
	if (place_meeting(x, y, obj_wall) || place_meeting(x, y, obj_wall_phasable)) {
	    var steps_left = 0, steps_right = 0;
    
	    // Check how many steps to escape left
	    while (place_meeting(x - steps_left, y, obj_wall) || place_meeting(x - steps_left, y, obj_wall_phasable)) {
	        steps_left++;
	        if (steps_left > 50) break; // Safety to prevent infinite loops
	    }
    
	    // Check how many steps to escape right
	    while (place_meeting(x + steps_right, y, obj_wall) || place_meeting(x + steps_right, y, obj_wall_phasable)) {
	        steps_right++;
	        if (steps_right > 50) break; // Safety
	    }
    
	    // Push in the direction requiring fewer steps
	    if (steps_left < steps_right) {
	        while (place_meeting(x, y, obj_wall) || place_meeting(x, y, obj_wall_phasable)) {
	            x -= 1; // Push left
	        }
	    } else {
	        while (place_meeting(x, y, obj_wall) || place_meeting(x, y, obj_wall_phasable)) {
	            x += 1; // Push right
	        }
	    }
	}
	
    // Apply vertical movement
    y += ySpeed;
	// Apply horizontal movement
    x += xSpeed;
    // Check for spikes
    if (place_meeting(x, y, obj_spikes)) {
        bubbled = true;
		
		if !audio_is_playing(snd_bubbled){ audio_sound_pitch(snd_bubbled, 1.5); audio_play_sound(snd_bubbled, 10, 0);}
    }
	
	var grounded = (place_meeting(x, y + 1, obj_wall) || place_meeting(x, y + 1, obj_wall_phasable));

	if (grounded && !wasGrounded && ySpeed >= 0) {
	    // Just landed
	    audio_play_sound(snd_land, 10, 0);
	}
	
	wasGrounded = grounded;
}

function player_state_locked(){

}