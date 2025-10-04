function wrap(_value, __max, __min = 0) {
	if (_value > __max) {
		return __min;
	} else if (_value < __min) {
		return __max;
	} else {
		return _value;
	}
}

global.midTransition = false;
global.roomTarget = -1;


function transition_place_sequence(_type){
	if (layer_exists("transition")) layer_destroy("transition");
	var _lay = layer_create(-999, "transition");
	var cam = view_camera[0];
	var cx = camera_get_view_x(cam) + camera_get_view_width(cam) * 0.5 ;
	var cy = camera_get_view_y(cam) + camera_get_view_height(cam) * 0.5;
	show_debug_message(cx);
	show_debug_message(cy);
	layer_sequence_create(_lay, cx, cy, _type);
}

function transition_start(_roomTarget, _typeOut, _typeIn)
{
	if (!global.midTransition)
	{
		global.midTransition = true;
		global.roomTarget = _roomTarget;
		transition_place_sequence(_typeOut);
		layer_set_target_room(_roomTarget)
		layer_reset_target_room();
		return true;
	}
	else return false
}

//Called as a moment at the end of an "Out" transition sequence
function transition_change_room()
{
	room_goto(global.roomTarget);
}

//Called as a moment at the end of an "In" transition sequence
function transition_finished()
{
	layer_sequence_destroy(self.elementID);
	global.midTransition = false;
}

function get_formatted_time(){
	/// returns the speedrun timer, formatted as a string to look like hours:minutes:seconds:centiseconds
	// note to self: the speedrun_timer var is already stored in seconds, with accuracy to the millionth decimal position (10^-6)
	// the descriptions of the following code uses "real seconds" to describe global.speedrun_timer

	// hours: acquired by dividing the real seconds by the number of seconds in an hour, 
	//  then shaving off the remainder by rounding down.
	hours = floor(global.speedrun_timer / 3600);

	// minutes: acquired by subtracting the number of seconds taken up in hours from the real seconds,
	//  dividing that result by the number of seconds in a minute, 
	//  then shaving off the remainder by rounding down.
	minutes = floor( (global.speedrun_timer - (3600*hours)) / 60 );

	// seconds: acquired by subtracting the number of seconds taken up in hours from the real seconds,
	//  also subtracting the number of seconds taken up in minutes from the real seconds, 
	//  then shaving off the remainder by rounding down.
	seconds = floor( (global.speedrun_timer - (3600*hours) - (60*minutes)) );

	// store the remainder (always a decimal number smaller than 1 second) for any other use,
	//  by subtracting the rounded-down integer version of the real seconds from the real seconds.
	remainder = global.speedrun_timer - floor(global.speedrun_timer);

	// get an integer representing two decimal places from the remainder by multiplying by 100, then rounding down.
	centiseconds = floor(remainder*100);

	// the following lines convert the time values into strings for use in displaying them,
	//  sometimes adding a 0 if the string length is only one digit.

	str_hours = string(hours);

	str_minutes = string(minutes);
	if(string_length(str_minutes) < 2) { str_minutes = "0"+str_minutes; }

	str_seconds = string(seconds);
	if(string_length(str_seconds) < 2) { str_seconds = "0"+str_seconds; }

	str_centiseconds = string(centiseconds);
	if(string_length(str_centiseconds) < 2) { str_centiseconds = "0"+str_centiseconds; }

	// return the final formatted string result with colons between the numbers. 
	return str_hours+":"+str_minutes+":"+str_seconds+":"+str_centiseconds;
}