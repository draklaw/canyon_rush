class_name Utils

static func sum (v: Array):
	var s = 0
	for x in v:
		s += x
	return s

static func interpol (v1: Array, v2: Array, l: float) -> Array:
	var vr = []
	for i in range(v1.size()):
		vr.append(l*v1[i] + (1-l)*v2[i])
	return vr
