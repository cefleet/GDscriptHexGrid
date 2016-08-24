# GDscriptHexGrid
A hex grid engine with a* pathfinding included

This was the first thing I did in GD script so it really could be much better. However I was asked to share it and I am willing to.
I had started to re-write it in c++ but never finshed it so that is included as well. This is the only thing I have ever written in c++ so don't judge me.

It is also very poorly documented.

**Usage for GDscript:**
```python
var HexAPI = load("res://'folderToGDscriptHexGrid'/HexAPI.gd").new()

var to = HexAPI.engine._hex(q,r,s)

var from = HexAPI.engine._hex(q,r,s)

var obstacles = [HexAPI.engine._hex(q,r,s),HexAPI.engine._hex(q,r,s),HexAPI.engine._hex(q,r,s)]

#Below only needs to be run when the distances is looking for is changed
HexAPI.astar._astarGridSetup(obstacles,arrayOfHexes)

var hexes = HexAPI.astar._aStarGetPathTo(from,to, obstacles)
```

**Notes for c++ **
- Astar does not work ...Not really going to make it work.
- hex and points are literally just Vector3 and Vector2 respectivly. I never understood how to make my own variant or if I should even try.
- I don't know c++, so this is bad c++



----------------------------------------------------------------------------
"THE BEER-WARE LICENSE" (Revision clint's revision):
clint modified this file. As long as you retain this notice,
(or even if you don't) you can do whatever you want with this stuff as long
as clint isn't blamed for bad stuff you do. If we meet some day, and you think
this stuff is worth it, you can buy me a beer in return.
Clint Fleetwoood (Originally Poul-Henning Kamp)

---------------------------------------------------------------------------- 

