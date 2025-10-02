state = player_state_free;

jumpSpeed = 3;
runSpeed = 5;
Acceleration = 0.2;
Decceleration = 0.5
accelFinal = 0;
lastH = 0;
grav = .275;
terminal = 4;


xSpeed = 0;
ySpeed = 0;
jumpSpeed = -4

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