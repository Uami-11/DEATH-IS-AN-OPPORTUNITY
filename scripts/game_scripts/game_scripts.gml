function wrap(_value, __max, __min = 0) {
	if (_value > __max) {
		return __min;
	} else if (_value < __min) {
		return __max;
	} else {
		return _value;
	}
}