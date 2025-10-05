function player_change_animation(_input, _timer){
    obj_invisi_camera.x = x;
    obj_invisi_camera.y = y;
    var dt = delta_time / 1000000;
    var anim_speed = dt * 60;
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
            image_speed = anim_speed;
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
        image_speed = anim_speed;
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
    
    var dt = delta_time / 1000000;
    var multiplier = dt * 60;
    player_change_animation(0, hurtTimer);
    
    if !place_meeting(x, y-10 * multiplier, obj_wall){
        y -= 1 * multiplier;
    } else {bubbled = false; audio_play_sound(snd_popped, 10, 0); }
    var inst = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_fog, false, true);
    if (inst != noone) {
        x += 5 * multiplier * inst.dir;
    } else {
        timer += multiplier;
        x += sin(timer*0.03) * 0.5 * multiplier;
    }
    if place_meeting(x, y-11 * multiplier, obj_bubble_trap){
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
    hurtTimer -= multiplier;
    show_debug_message(string_concat("hurtTimer: ", hurtTimer))
}


function player_physics_step(_move_input, _jump_pressed) {
    var dt = delta_time / 1000000;
    var multiplier = dt * 60;
    // === Jump Buffering ===
    if (_jump_pressed) {
        jumpBufferCount = 0;
    }
    var can_buffer_jump = (jumpBufferCount < jumpBuffer);
    if (jumpBufferCount < jumpBuffer) {
        jumpBufferCount += multiplier;
        if (jumpBufferCount > jumpBuffer) jumpBufferCount = jumpBuffer;
    }
    

    // === Horizontal Movement ===
    var on_ground = (place_meeting(x, y + 1, obj_wall) || place_meeting(x, y + 1, obj_wall_phasable)); // On ground
    if (on_ground) {
        if (_move_input == 0 || (xSpeed * _move_input < 0)) {
            xSpeed -= xSpeed * brakeRateGround * multiplier;
        }
        xSpeed += _move_input * accelRateGround * multiplier;
    } else { // In air
        if (_move_input == 0 || (xSpeed * _move_input < 0)) {
            xSpeed -= xSpeed * brakeRateAir * multiplier;
        }
        xSpeed += _move_input * accelRateAir * multiplier;
    }

    // Clamp speed
    xSpeed = clamp(xSpeed, -runSpeed, runSpeed);

    // === Gravity ===
    if (ySpeed < gravMax || !on_ground) {
        ySpeed += gravRate * multiplier;
    }

    // === Jump (coyote / ledge buffer) ===
    if (on_ground && can_buffer_jump) {
        ySpeed = jumpSpeed;
        jumpBufferCount = jumpBuffer; // consume buffer
        audio_sound_pitch(snd_jump, 0.65);
        audio_play_sound(snd_jump, 10, 0);
    }

    // === Collision Resolution ===
    // Horizontal (sides)
    var move_x = xSpeed * multiplier;
    if (move_x != 0 && (place_meeting(x + move_x, y, obj_wall) || place_meeting(x + move_x, y, obj_wall_phasable))) {
        var _dir = sign(move_x);
        var abs_move = abs(move_x);
        var floor_move = floor(abs_move);
        var _frac = abs_move - floor_move;
        var first_k = floor_move + 2;
        for (var k = 1; k <= floor_move + 1; k++) {
            if (place_meeting(x + k * _dir, y, obj_wall) || place_meeting(x + k * _dir, y, obj_wall_phasable)) {
                first_k = k;
                break;
            }
        }
        var integer_moved;
        if (first_k > floor_move + 1) {
            integer_moved = floor_move;
        } else {
            integer_moved = first_k - 1;
        }
        x += integer_moved * _dir;
        if (integer_moved < floor_move) {
            xSpeed = 0;
        } else {
            if (place_meeting(x + move_x, y, obj_wall) || place_meeting(x + move_x, y, obj_wall_phasable)) {
                xSpeed = 0;
            } else {
                x += _frac * _dir;
            }
        }
    } else {
        x += move_x;
    }

    // Vertical (top/bottom)
    var move_y = ySpeed * multiplier;
    if (move_y != 0 && (place_meeting(x, y + move_y, obj_wall) || place_meeting(x, y + move_y, obj_wall_phasable))) {
        var _dir = sign(move_y);
        var abs_move = abs(move_y);
        var floor_move = floor(abs_move);
        var _frac = abs_move - floor_move;
        var first_k = floor_move + 2;
        for (var k = 1; k <= floor_move + 1; k++) {
            if (place_meeting(x, y + k * _dir, obj_wall) || place_meeting(x, y + k * _dir, obj_wall_phasable)) {
                first_k = k;
                break;
            }
        }
        var integer_moved;
        if (first_k > floor_move + 1) {
            integer_moved = floor_move;
        } else {
            integer_moved = first_k - 1;
        }
        y += integer_moved * _dir;
        if (integer_moved < floor_move) {
            ySpeed = 0;
        } else {
            if (place_meeting(x, y + move_y, obj_wall) || place_meeting(x, y + move_y, obj_wall_phasable)) {
                ySpeed = 0;
            } else {
                y += _frac * _dir;
            }
        }
    } else {
        y += move_y;
    }
	
	// Resolve current overlaps (prioritize shortest escape direction)
	if (place_meeting(x, y, obj_wall) || place_meeting(x, y, obj_wall_phasable)) {
	    var steps_left = 0;
	    var steps_right = 0;

	    // How many pixels to escape left
	    while (place_meeting(x - steps_left, y, obj_wall) || place_meeting(x - steps_left, y, obj_wall_phasable)) {
	        steps_left++;
	        if (steps_left > 50) break; // safety
	    }

	    // How many pixels to escape right
	    while (place_meeting(x + steps_right, y, obj_wall) || place_meeting(x + steps_right, y, obj_wall_phasable)) {
	        steps_right++;
	        if (steps_right > 50) break; // safety
	    }

	    // Push in one go (no loop)
	    if (steps_left < steps_right) {
	        x -= steps_left;
	    } else {
	        x += steps_right;
	    }
	}

	
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