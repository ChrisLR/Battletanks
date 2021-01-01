extends Node


var amountPlayers:int = 1
var PlayerControls = ["K1", "K2"]


enum Direction {
	North = 0,
	West = 1,
	South = 2,
	East = 3,
}

const DirectionVector = {
	Direction.North: Vector2.UP,
	Direction.East: Vector2.RIGHT,
	Direction.South: Vector2.DOWN,
	Direction.West: Vector2.LEFT,
}
