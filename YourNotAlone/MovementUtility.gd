extends Node

enum moveDirection {
	left,
	right,
	up,
	down
}

var lastPlayerDirection

func reset():
	lastPlayerDirection = null
