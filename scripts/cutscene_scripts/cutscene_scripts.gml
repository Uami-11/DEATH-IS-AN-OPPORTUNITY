///@param _scene_info
function create_cutscene(_scene_info){
	var inst = instance_create_layer(0, 0, "Tops", obj_cutscene);
	with (inst){
		scene_info = _scene_info;
		event_perform(ev_other, ev_user0)
	}
}



///@description script_execute_alt
///@arg ind
///@arg [arg1,arg2,...]
function script_execute_alt(){
	var s = argument0;
	var a = argument1;
	var len = array_length(argument1);
	var result;
 
	switch(len){
	    case 0 : result = script_execute(s); break;
	    case 1 : result = script_execute(s, a[0]); break;
	    case 2:  result = script_execute(s, a[0], a[1]); break;
	    case 3:  result = script_execute(s, a[0], a[1], a[2]); break;
	    case 4:  result = script_execute(s, a[0], a[1], a[2], a[3]); break;
	    case 5:  result = script_execute(s, a[0], a[1], a[2], a[3], a[4]); break;
	    case 6:  result = script_execute(s, a[0], a[1], a[2], a[3], a[4], a[5]); break;
	    case 7:  result = script_execute(s, a[0], a[1], a[2], a[3], a[4], a[5], a[6]); break;
	    case 8:  result = script_execute(s, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]); break;
	    case 9:  result = script_execute(s, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]); break;
	    case 10: result = script_execute(s, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9]); break;
	    case 11: result = script_execute(s, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10]); break;
	    case 12: result = script_execute(s, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]); break;
	    case 13: result = script_execute(s, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12]); break;
	    case 14: result = script_execute(s, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13]); break;
	    case 15: result = script_execute(s, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14]); break;
	}

	if (result != undefined) global.last_result = result;
	show_debug_message(global.last_result)
}

function cutscene_end_action(){
	scene++;
	if (scene > array_length(scene_info)-1){
		show_debug_message("Bruh")
		instance_destroy(obj_cutscene);
		exit;
	}
	event_perform(ev_other, ev_user0);
	show_debug_message("Next Scene")
}

///@param _secs = seconds
function cutscene_wait(_secs){
	timer++;
	show_debug_message("Waiting...")
	if (timer >= _secs * game_get_speed(gamespeed_fps)){
		timer = 0;
		cutscene_end_action();
	}
}

function create_box_at_mouse(){
	if mouse_check_button_pressed(mb_left){
		instance_create_layer(mouse_x, mouse_y, "Tops", obj_wall);
		cutscene_end_action()
	}
}


///@param soundid
///@param priority
///@param loops
function cutscene_play_sound(soundid, priority, loops){
	show_debug_message("Played Sound")
	audio_play_sound(soundid, priority, loops);
	cutscene_end_action()
}

///@param _x
///@param _y
///@param _depth
///@param obj

function cutscene_create_instance(_x, _y, _depth, obj){
	show_debug_message("Instance Created")
	var inst = instance_create_depth(_x, _y, _depth, obj)
	cutscene_end_action()
	return inst;
}


///@param obj_id
function cutscene_instance_destroy(obj_id){
	show_debug_message("Instances Destroyed")
	with(obj_id){
		instance_destroy()
	}
	cutscene_end_action()
}

///@param _x
///@param _y
///@param obj

function cutscene_instance_destroy_nearest(_x, _y, obj){
	show_debug_message("Nearest Instance Destroyed")
	var inst = instance_nearest(_x, _y, obj);
	
	cutscene_instance_destroy(inst);
}

///@arg obj
///@arg _image_xscale

function cutscene_change_xscale(){
	show_debug_message("X Scaled")
	if argument_count > 1 {
		with (argument[0]){
			image_xscale = argument[1];
		}
	}
	else {
		with (argument[0]){
			image_xscale *= -1;
		}
	}
	cutscene_end_action();
}

/// @param glob  whether it's global (true/false)
/// @param var_name  the variable name (string)
/// @param value  the value to assign
/// @param obj  (optional) the instance, if not global

function cutscene_change_variable(glob, var_name, value, obj) {
	show_debug_message("Variable changed")
    if (glob) {
        // Global variable case
        if (variable_global_exists(var_name)) {
            variable_global_set(var_name, value);
        } else {
          result =   show_debug_message("Global variable '" + string(var_name) + "' does not exist.");
        }
    } else {
        // Instance variable case
        if (argument_count == 4 && instance_exists(obj)) {
            variable_instance_set(obj, var_name, value);
        } else {
            show_debug_message("Instance or argument missing for variable '" + string(var_name) + "'.");
        }
    }

    cutscene_end_action();
}

///@param obj
///@param _x
///@param _y
///@param relative ?
///@param spd

function cutscene_move_character(obj, _x, _y, relative, spd){
	if (xDest == -1){
		if (!relative){
			xDest = _x;
			yDest = _y;
		} else {
			xDest = obj.x + _x;
			yDest = obj.y + _y;
		}
	}

	var xx = xDest;
	var yy = yDest;

	with (obj){
		if (point_distance(x, y, xx, yy) >= spd){
			var dir = point_direction(x, y, xx, yy);
			var ldirx = lengthdir_x(spd, dir);
			var ldiry = lengthdir_y(spd, dir);
			show_debug_message("Moving...")
			obj.xSpeed = ldirx;
			obj.ySpeed = ldiry;
		} else {
			x = xx;
			y = yy;
			obj.xSpeed = 0;
			obj.ySpeed = 0;
			with (other){
				xDest = -1;
				yDest = -1;
				cutscene_end_action();
			}
		}
	}
}

function cutscene_create_dialogue(_texID){
	create_textbox(_texID);
}

///@param [obj]
function cutscene_set_camera(obj){
	
	camera_set_view_target(view_camera[0], -1)
	camera_set_view_target(view_camera[0], obj)
	
	show_debug_message("Changed Camera")
	cutscene_end_action()
}