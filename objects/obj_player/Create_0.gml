state = player_state_free;

/// Physics Vars (renamed to your style)
runSpeed = 6;                // Max horizontal speed
jumpSpeed = -5;              // Negative = upward
jumpBufferCount = 0;         // Tracks buffered jump frames
jumpBuffer = 10;             // How long a jump press is stored
coyoteFrames = 2;           // "Ledge buffer" / coyote time
accelRateGround = 0.3;
accelRateAir = 0.2;
brakeRateGround = 0.4;
brakeRateAir = 0.2;
gravMax = 8;                 // Max fall speed
gravRate = 0.2;              // Gravity strength

// Motion state
xSpeed = 0;
ySpeed = 0;

bufferTime = 6;
	
jumpKeyBuffered = 0;
jumpKeyBufferTimer = 0;

coyoteHangFrames = 4;
coyoteHangTimer = 0;

onGround = false;

function setOnGround(_val = true){
	if _val {
		onGround = true;
		coyoteHangTimer =coyoteHangFrames;
	} else {
		onGround = false;
		coyoteHangTimer = 0;
	}
}

bubbled = false;

startX = 0;
timer = -1;
hurtTimer = 400;
wasGrounded = false;
died = false;