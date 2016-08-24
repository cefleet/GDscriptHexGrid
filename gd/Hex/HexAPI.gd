extends Node

var engine
var grid
var hex
var astar
func _init(obj={}):
	#we only need 1 instance of engine
	engine = load("res://Modules/Hex/HexEngine.gd").new()
	
	obj.engine = engine
	grid = load("res://Modules/Hex/HexGrid.gd").new(obj)
	
	astar = load("res://Modules/Hex/HexAstar.gd").new()
	astar.engine = engine
	astar.hGrid = grid
	