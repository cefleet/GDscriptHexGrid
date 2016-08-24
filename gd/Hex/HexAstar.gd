extends Object
var engine
var hGrid
var grid 

func _aStarGetPathTo(startHex,endHex,obstacles,dist = 4):

	var i
	var start
	var end

	for i in range(grid.size()):

		_resetNHex(i)
		if grid[i].id == startHex:
			start = grid[i]
		
		if grid[i].id == endHex:
			end = grid[i]

	var openList = []
	var closedList = []
	openList.append(start)
	

	while openList.size() > 0:
		# Grab the lowest f(x) to process nextvar 
		var lowInd = 0
		for i in range(openList.size()):
			if openList[i].f < openList[lowInd].f:
				lowInd = i
		var currentNode = openList[lowInd]
		
		if currentNode == end:
			var curr = currentNode
			var ret = [];
			while curr.parent != null:
				ret.append(curr)
				curr = curr.parent           

			ret.invert()
			return ret

		openList.remove(lowInd)
		currentNode.closed = true
		
		for i in range(currentNode.neighbors.size()):
			#if grid was a dictonary this could be cut out 
			var neighbor = _getAstarGridItemFromId(currentNode.neighbors[i])
			
			if neighbor != null:
				if(neighbor.size() < 1 || neighbor.closed || neighbor.isObstacle):
					continue
			
				var gScore = float(currentNode.g) + 1
				var gScoreIsBest = false
				if !neighbor.visited:
					gScoreIsBest = true
					neighbor.h = _astarHeuristic(neighbor, end)
					neighbor.visited = true
					openList.append(neighbor)

				elif gScore < neighbor.g:
					gScoreIsBest = true
			
				if gScoreIsBest:
					neighbor.parent = currentNode
					neighbor.g = gScore
					neighbor.f = neighbor.g + neighbor.h

	return [];

func  _astarHeuristic(pos,end):
	return engine._distanceBetween(pos,end)

func _astarGridSetup(obstacles=[],list=[]):
	grid = []
	
	if list.size() < 1:
		for hex in hGrid.map:
			var nHex = _astartGridifyFromId(hex)
			if obstacles.size() > 0:
				for obs in obstacles:
					if obs.id == nHex.id:
						nHex.isObstacle = true
			grid.append(nHex)
	else:
		for hex in list:
			var nHex = _astartGridifyFromId(hex)
			if nHex != null:
				if obstacles.size() > 0:
					for obs in obstacles:
						if obs.id == nHex.id:
							nHex.isObstacle = true
				grid.append(nHex)
	return grid

func _getAstarGridItemFromId(id):
	for i in range(grid.size()):
		if grid[i].id == id:
			return grid[i]

func _resetNHex(i):
	grid[i].f = 0
	grid[i].g = 0
	grid[i].h = 0
	grid[i].debug = ""
	grid[i].parent = null
	grid[i].closed = false
	grid[i].visited = false
	
func _astartGridifyFromId(hex):
	var nHex = {}
	nHex.id = hex
	if hex in hGrid.map:
		nHex.neighbors = engine._neighbors(hGrid.map[hex])
		nHex.q = hGrid.map[hex].q
		nHex.r = hGrid.map[hex].r
		nHex.s = hGrid.map[hex].s
		nHex.f = 0
		nHex.g = 0
		nHex.h = 0
		nHex.debug = ""
		nHex.parent = null
		nHex.isObstacle = false
		nHex.closed = false
		nHex.visited = false
		return nHex