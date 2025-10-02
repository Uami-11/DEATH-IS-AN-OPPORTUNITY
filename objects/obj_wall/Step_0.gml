if moving {
	if distance > 0{
		x += 1;
	} else {
		x -= 1;
	}
	distance++;
	distance = wrap(distance, moveDistance, -moveDistance);
	
	
}