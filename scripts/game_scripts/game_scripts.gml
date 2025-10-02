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