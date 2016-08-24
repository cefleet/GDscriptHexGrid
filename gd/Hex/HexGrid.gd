extends Node
var hexSize
var origin
var orientation
var layout
var map
var rows 
var cols
var engine
#var Hex
func _init(options={}):
	if not 'hexSize' in options:
		hexSize = {'x':2.75,'y':2.75}
	
	if not 'origin' in options:
		origin = {'x':10,'y':-66}
	
	if not 'orientation' in options:
		orientation = 'flat'
	
	if not 'cols' in options:
		cols = 16
		
	if not 'rows' in options:
		rows = 16
			
	engine = options.engine
	
	layout = engine._createLayout(hexSize,origin,orientation)
		
	_createMap()

func _createMap():
	map = {}
	if orientation == 'pointy':
		_makePointyMap()
	else:
		_makeFlatMap()

func _makePointyMap():
	for r in range(rows):
		var r_offset = floor(r/2)

		for q in range(-r_offset, cols-r_offset,1):
			var h = engine._hex(q,r,-q-r)
			map[h.id] = h

func _makeFlatMap():
	for q in range(cols):
		var q_offset = floor(q/2)
		for r in range(-q_offset,rows-q_offset,1):
			var h = engine._hex(q,r,-q-r)
			map[h.id] = h