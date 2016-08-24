extends Object #dont know if this should be a node or something else

const EVEN = 1
const ODD = -1
var LAYOUT
var DIRECTIONS
var DIAGONALS

func _init():
	
	LAYOUT = {
		"POINTY" : _orientation(sqrt(3.0), sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0, sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0, 0.5),
		"FLAT" : _orientation(3.0 / 2.0, 0.0, sqrt(3.0) / 2.0, sqrt(3.0), 2.0 / 3.0, 0.0, -1.0 / 3.0, sqrt(3.0) / 3.0, 0.0)
    }
	DIRECTIONS = [_hex(1, 0, -1), _hex(1, -1, 0), _hex(0, -1, 1), _hex(-1, 0, 1), _hex(-1, 1, 0), _hex(0, 1, -1)]
	DIAGONALS = [_hex(2, -1, -1), _hex(1, -2, 1), _hex(-1, -1, 2), _hex(-2, 1, 1), _hex(-1, 2, -1), _hex(1, 1, -2)]

func _hex(q,r,s):
	return {'q': q, 'r': r, 's': s,'id':str(q)+'.'+str(r)+'.'+str(s)};

func _point(x,y):
	return {'x':x,'y':y}

func _hexAdd(a,b):
	return _hex(int(a.q) + int(b.q), int(a.r) + int(b.r), int(a.s) + int(b.s))

func _hexSubtract(a,b):
	return _hex(a.q - b.q, a.r - b.r, a.s - b.s)

func _hexScale(a,k):
	return _hex(a.q * k, a.r * k, a.s * k);

func _direction(d):
	return DIRECTIONS[d]

func _diagonal(d):
	return DIAGONALS[d]

func _distanceBetween(hexA,hexB):
	if hexA != null && hexB != null:
		return (abs(float(hexA.q)-float(hexB.q))+abs(float(hexA.q)+int(hexA.r)-float(hexB.q)-float(hexB.r))+abs(float(hexA.r)-float(hexB.r)))/2
	else:
		#arbarturary
		return 1000

func _neighborAtDirection(hex, dir):
	return _hexAdd(hex, _direction(dir))

func _neighborsAtDiagonal(hex, dir):
	return _hexAdd(hex, _diagonal(dir))

func _neighbors(hex):
	var neighbors = []
	for i in range(6):
		var n = _neighborAtDirection(hex,i)
		neighbors.append(str(n.q)+'.'+str(n.r)+'.'+str(n.s))
	return neighbors


func _edges(hex,layout):
	var edges = [];
	var corners = _cornersOfHex(layout,hex)
	for i in range(corners.size()):
		var l = i+1
		if l == 6:
			l = 0
		edges.append([corners[l],corners[i]])
	return edges

func _orientation(f0, f1, f2, f3, b0, b1, b2, b3, start_angle):
	return {'f0': f0, 'f1': f1, 'f2': f2, 'f3': f3, 'b0': b0, 'b1': b1, 'b2': b2, 'b3': b3, 'start_angle': start_angle};

func _createLayout(hexSize,origin, orient=null):
	var o;
	if orient == 'pointy':
		o = LAYOUT.POINTY
	else:
		o = LAYOUT.FLAT
	return {'orientation': o, 'hexSize': hexSize, 'origin': origin}

func _centerOfHex(layout,hex):
	var M = layout.orientation
	var hexSize = layout.hexSize
	var origin = layout.origin
	var x = float(float(M.f0) * float(hex.q) + float(M.f1) * float(hex.r)) * float(hexSize.x)
	var y = float(float(M.f2) * float(hex.q) + float(M.f3) * float(hex.r)) * float(hexSize.y)
	return _point(x + origin.x, y + origin.y)

func _roundToHex(hex):
	#using int instead of math.trunc
	var q = float(round(hex.q))
	var r = float(round(hex.r))
	var s = float(round(hex.s))
	var q_diff = abs(q - hex.q)
	var r_diff = abs(r - hex.r)
	var s_diff = abs(s - hex.s)
	if q_diff > r_diff && q_diff > s_diff:
		q = -r - s
	elif r_diff > s_diff:
		r = -q - s
	else:
		s = -q - r
	if q == -0:
		q = 0
	if r == -0:
		r = 0
	if s == -0:
		s = 0
	return _hex(q, r, s)

func _cornerOffset(layout,corner):
	var M = layout.orientation
	var hexSize = layout.hexSize
	var angle = 2.0 * PI * (corner + M.start_angle) / 6
	return _point(hexSize.x * cos(angle), hexSize.y * sin(angle))
	
func _cornersOfHex(layout,h):
#this one has been modified quite a bit
	var corners = []
	var center = _centerOfHex(layout, h)
	for i in range(1,7):
		var offset = _cornerOffset(layout, i);
		corners.append(_point(center.x + offset.x, center.y + offset.y))
	return corners

func _hexAtPoint(layout,p):
	var M = layout.orientation
	var hexSize = layout.hexSize
	var origin = layout.origin
	var pt = _point((p.x - origin.x) / hexSize.x, (p.y - origin.y) / hexSize.y)
	var q = M.b0 * pt.x + M.b1 * pt.y
	var r = M.b2 * pt.x + M.b3 * pt.y
	var frHex = _hex(q, r, -q - r)
	return _roundToHex(frHex)

func _getHexesWithinDistance(hex,dist):
	var results = [{'q':hex.q,'r':hex.r,'s':hex.s}]
	for i in range(1,dist):
    #for(var i = 1; i <= dist; i++){
		var n = _getHexesAtDistance(hex,i)
		for l in n:
#      for(var l = 0; l < n.length; l++){
			results.append(l)
	
	return results

#this one I am not sure if it works
func _getHexesAtDistance(hex,dist):
	var results = [];
	var pHex = _hexAdd(hex,_hexScale(_direction(4), dist))
	for i in range(6):
		for j in range(dist):
			results.append(pHex)
			pHex = _neighborAtDirection(pHex,i)
	return results
	
func _hexLerp(a,b,t):
	return _hex(float(a.q)+(float(b.q)-float(a.q))*float(t), float(a.r)+(float(b.r)-float(a.r))*float(t), float(a.s)+(float(b.s)-float(a.s))*float(t))

func _defineLineBetweenHexes(a,b):
	var N = _distanceBetween(a, b)
	var results = []
	var step = float(1)/float(max(N,1))
	for i in range(N+1):
		var l = _hexLerp(a, b, step*i)
		results.append(_roundToHex(l))
	return results

func _checkIfLinesIntersect(l1,l2):
	var result = false
	var line1StartX = l1[0].x
	var line1StartY = l1[0].y
	var line1EndX = l1[1].x
	var line1EndY = l1[1].y

	var line2StartX = l2[0].x
	var line2StartY = l2[0].y
	var line2EndX = l2[1].x
	var line2EndY = l2[1].y

	var denominator = ((line2EndY - line2StartY) * (line1EndX - line1StartX)) - ((line2EndX - line2StartX) * (line1EndY - line1StartY));

	if denominator == 0:
		return result
   
	var a = line1StartY - line2StartY
	var b = line1StartX - line2StartX
	var numerator1 = ((line2EndX - line2StartX) * a) - ((line2EndY - line2StartY) * b)
	var numerator2 = ((line1EndX - line1StartX) * a) - ((line1EndY - line1StartY) * b)
	var a = numerator1 / denominator
	var b = numerator2 / denominator

	if a > 0 && a < 1 && b > 0 && b < 1:
		result = true
 
	return result


func _getLOS(hex,dist,layout,obstacles=[],list=null):
	var outList =[]
	if list == null:
		list = _getHexesWithinDistance(hex, dist)
		
	for i in range(list.size()):
		if(_getSingleLOS(list[i],hex,obstacles,layout)):
			outList.append(list[i])
	
	return outList

#obstacles is a list of hexes
func _getSingleLOS(start, finish,obstacles=[],layout=LAYOUT.FLAT):
	var clear = true
	var line = [_centerOfHex(layout,start), _centerOfHex(layout,finish)]
	#This offcenters it just enough to not go through the point
	line[0].y = line[0].y+0.5
	for i in range(obstacles.size()):

		if line.size() == 2 && obstacles.size() > i:
			if _checkIfLineIntersectsHex(obstacles[i],line,layout):
				clear = false
	return clear


func _checkIfLineIntersectsHex(hex,line,layout):
	var crosses = false
	var edges = _edges(hex,layout)
	for i in range(edges.size()):
		if edges.size() > i:
			if _checkIfLinesIntersect(line,edges[i]):
				crosses = true
    return crosses
