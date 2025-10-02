function player_state_free(){
	xSpeed = keyRight - keyLeft;
	
	if coyoteHangTimer > 0 {
		coyoteHangTimer--
	} else {
		ySpeed += grav;
		setOnGround(false);
	}

	if ySpeed > terminal {
		ySpeed = terminal;
	}

	var topSpeed = runSpeed;
	var dir = sign(xSpeed)



	if (dir != 0){
	
		if lastH != xSpeed {
			lastH = xSpeed;
			accelFinal = 0;
		}
		if accelFinal <= topSpeed {
			accelFinal += Acceleration;
		} 
		
	
	} else {
		if accelFinal > 0{
			accelFinal -= Decceleration;
		}

	}

	if accelFinal < Acceleration{
		accelFinal = 0;
		lastH = 0;
	
	}
	if accelFinal > topSpeed {
		accelFinal = topSpeed
	}


	xSpeed = accelFinal * lastH

	var _subPixel = .5;
	if (place_meeting(x + xSpeed, y, obj_wall)){

	    var _pixelCheck = _subPixel * sign(xSpeed);
	    while (!place_meeting(x + _pixelCheck, y, obj_wall)){
	        x+= _pixelCheck;
	    }

	    // set xspd to zero to collide
	    xSpeed = 0;
	}

	if (jumpKeyBuffered && onGround){
	
		// buffer reset
		jumpKeyBuffered = false;
		jumpKeyBufferTimer = 0;
	
	    ySpeed = jumpSpeed; 
	}

	var _subPixel = .5;
	if place_meeting(x, y + ySpeed, obj_wall){
    
	    var _pixelCheck = _subPixel * sign(ySpeed);
	    while (!place_meeting(x, y + _subPixel, obj_wall)){
	        y += _pixelCheck;
	    }
	    ySpeed = 0;
    
	}

	if ySpeed >= 0 and place_meeting(x, y+1, obj_wall){
		setOnGround();
	}

	x += xSpeed;
	y += ySpeed

	
	show_debug_message(accelFinal)
}

function player_state_bubble(){
	
	
	y -= 1;
	x += sin(timer*0.03) * 0.5;
	
	timer++;
	
}