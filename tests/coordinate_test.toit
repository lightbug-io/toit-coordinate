import coordinate show Coordinate
import fixed-point show FixedPoint

main:
    testdistanceToCoord
    testdistanceToCoord1km
    testdistanceToCoord100km
    testdistanceToCoordNegativeCoords
    testInCircle
    testInPolygon
    testComplexPolygon
    testdistanceToLine
    testBearingTo
    testdistanceToPolygonEdge
    testdistanceToPolygon

testdistanceToCoord:
    coord1 := Coordinate 0.0 0.0
    coord2 := Coordinate 0.0000899 0.0
    distance := coord1.distanceToCoord coord2
    if distance != 9.996423905345830363:
        print "❌ Expected 9.996423905345830363, got $distance"
    else:
        print "✅ testdistanceToCoord passed"

testdistanceToCoord1km:
    coord1 := Coordinate 0.0 0.0
    coord2 := Coordinate 0.00899 0.0
    distance := coord1.distanceToCoord coord2
    if distance != 999.64239053458311446:
        print "❌ Expected 999.64239053458311446, got $distance"
    else:
        print "✅ testdistanceToCoord1km passed"

testdistanceToCoord100km:
    coord1 := Coordinate 0.0 0.0
    coord2 := Coordinate 0.899 0.0
    distance := coord1.distanceToCoord coord2
    if distance != 99964.239053458311446:
        print "❌ Expected 99964.239053458311446, got $distance"
    else:
        print "✅ testdistanceToCoord100km passed"

testdistanceToCoordNegativeCoords:
    coord1 := Coordinate 0.0 0.0
    coord2 := Coordinate -0.00899 0.0
    distance := coord1.distanceToCoord coord2
    if distance != 999.64239053458311446:
        print "❌ Expected 999.64239053458311446, got $distance"
    else:
        print "✅ testdistanceToCoordNegativeCoords passed"

testInCircle:
    center := Coordinate 0.0 0.0
    insideCoord := Coordinate 0.0000899 0.0
    outsideCoord := Coordinate 0.01 0.0
    radius := 10.0

    if not (insideCoord.inCircle center radius):
        print "❌ Expected insideCoord to be inside the circle"
    else:
        print "✅ testInCircle (inside) passed"

    if outsideCoord.inCircle center radius:
        print "❌ Expected outsideCoord to be outside the circle"
    else:
        print "✅ testInCircle (outside) passed"

testInPolygon:
    boundary := [
      Coordinate 0.0 0.0,
      Coordinate 0.0 1.0,
      Coordinate 1.0 1.0,
      Coordinate 1.0 0.0
    ]
    insideCoord := Coordinate 0.5 0.5
    outsideCoord := Coordinate 1.5 1.5

    if not (insideCoord.inPolygon boundary):
        print "❌ Expected insideCoord to be inside the polygon"
    else:
        print "✅ testInPolygon (inside) passed"

    if outsideCoord.inPolygon boundary:
        print "❌ Expected outsideCoord to be outside the polygon"
    else:
        print "✅ testInPolygon (outside) passed"

testComplexPolygon:
    // https://www.keene.edu/campus/maps/tool/?coordinates=-72.5125122%2C%2042.8548264%0A-72.3298645%2C%2042.8646412%0A-72.4685669%2C%2042.9109261%0A-72.2814560%2C%2042.9104232%0A-72.3563004%2C%2042.9677285%0A-72.1933937%2C%2042.9184693%0A-72.2905540%2C%2043.0171994%0A-72.4927711%2C%2042.9910878%0A-72.5130272%2C%2042.8540713
    boundary := [
      Coordinate 42.8548264 -72.5125122,
      Coordinate 42.8646412 -72.3298645,
      Coordinate 42.9109261 -72.4685669,
      Coordinate 42.9104232 -72.2814560,
      Coordinate 42.9677285 -72.3563004,
      Coordinate 42.9184693 -72.1933937,
      Coordinate 43.0171994 -72.2905540,
      Coordinate 42.9910878 -72.4927711,
      Coordinate 42.8540713 -72.5130272
    ]
    insideCoords := [
      Coordinate 42.9410932 -72.2364807,
      Coordinate 42.9164579 -72.4208450,
      Coordinate 42.9861906 -72.4850464
    ]
    outsideCoords := [
      Coordinate 42.9439835 -72.3060036,
      Coordinate 42.9077829 -72.4472809,
      Coordinate 42.9810419 -72.5006676
    ]

    insideCoords.do: |coord|
      if not (coord.inPolygon boundary):
        print "❌ Expected $coord to be inside the polygon"
      else:
        print "✅ testComplexPolygon (inside) passed"

    outsideCoords.do: |coord|
      if coord.inPolygon boundary:
        print "❌ Expected $coord to be outside the polygon"
      else:
        print "✅ testComplexPolygon (outside) passed"

testdistanceToLine:
  testdistanceToLineOnP1
  testdistanceToLineOnP2
  testdistanceToLineOn10mFromP1
  testdistanceToLineOn10mFromP2
  testdistanceToLine10mFromMiddle
  testdistanceToLine10mFromMiddleOtherSide

testdistanceToLineOnP1:
  p1 := Coordinate 0.0 0.0
  p2 := Coordinate 0.1 0.0
  coord := Coordinate 0.1 0.0 // On the line, at the point 2
  distance := coord.distanceToLine p1 p2
  if distance != 0.0:
      print "❌ testdistanceToLineOnP1 Expected 0.0, got $distance"
  else:
      print "✅ testdistanceToLineOnP1 passed"

testdistanceToLineOnP2:
  p1 := Coordinate 0.0 0.0
  p2 := Coordinate 0.1 0.0
  coord := Coordinate 0.0 0.0 // On the line, at the point 1
  distance := coord.distanceToLine p1 p2
  if distance != 0.0:
      print "❌ testdistanceToLineOnP2 Expected 0.0, got $distance"
  else:
      print "✅ testdistanceToLineOnP2 passed"

testdistanceToLineOn10mFromP1:
  p1 := Coordinate 0.0 0.0
  p2 := Coordinate 0.1 0.0
  coord := Coordinate 0.1 0.0000899 // 10m from the line, at the point 2
  distance := coord.distanceToLine p1 p2
  distanceFixed := (FixedPoint distance --decimals=2)
  if distanceFixed != 10.0:
      print "❌ testdistanceToLineOn10mFromP1 Expected 10.0, got $distanceFixed"
  else:
      print "✅ testdistanceToLineOn10mFromP1 passed"

testdistanceToLineOn10mFromP2:
  p1 := Coordinate 0.0 0.0
  p2 := Coordinate 0.1 0.0
  coord := Coordinate 0.0 0.0000899 // 10m from the line, at the point 1
  distance := coord.distanceToLine p1 p2
  distanceFixed := (FixedPoint distance --decimals=2)
  if distanceFixed != 10.0:
      print "❌ testdistanceToLineOn10mFromP2 Expected 10.0, got $distanceFixed"
  else:
      print "✅ testdistanceToLineOn10mFromP2 passed"

testdistanceToLine10mFromMiddle:
  p1 := Coordinate 0.0 0.0
  p2 := Coordinate 1.0 0.0
  coord := Coordinate 0.5 0.0000899 // 10m from the line, in the middle
  distance := coord.distanceToLine p1 p2
  distanceFixed := (FixedPoint distance --decimals=0)
  if distanceFixed != 10.0:
      print "❌ testdistanceToLine10mFromMiddle Expected 10.0, got $distanceFixed"
  else:
      print "✅ testdistanceToLine10mFromMiddle passed"

testdistanceToLine10mFromMiddleOtherSide:
  p1 := Coordinate 0.0 0.0
  p2 := Coordinate 1.0 0.0
  coord := Coordinate 0.5 -0.0000899 // 10m from the line, in the middle
  distance := coord.distanceToLine p1 p2
  distanceFixed := (FixedPoint distance --decimals=0)
  if distanceFixed != 10.0:
      print "❌ testdistanceToLine10mFromMiddleOtherSide Expected 10.0, got $distanceFixed"
  else:
      print "✅ testdistanceToLine10mFromMiddleOtherSide passed"

testBearingTo:
    testBearingToEast
    testBearingToNorth
    testBearingToWest
    testBearingToSouth
    testBearingTo45

testBearingToEast:
    coord1 := Coordinate 0.0 0.0
    coord2 := Coordinate 0.0 1.0
    bearing := coord1.bearingTo coord2
    if bearing != 90.0:
        print "❌ Expected 90.0, got $bearing"
    else:
        print "✅ testBearingToEast passed"

testBearingToNorth:
    coord1 := Coordinate 0.0 0.0
    coord3 := Coordinate 1.0 0.0
    bearing := coord1.bearingTo coord3
    if bearing != 0.0:
        print "❌ Expected 0.0, got $bearing"
    else:
        print "✅ testBearingToNorth passed"

testBearingToWest:
    coord1 := Coordinate 0.0 0.0
    coord4 := Coordinate 0.0 -1.0
    bearing := coord1.bearingTo coord4
    if bearing != -90.0:
        print "❌ Expected -90.0, got $bearing"
    else:
        print "✅ testBearingToWest passed"

testBearingToSouth:
    coord1 := Coordinate 0.0 0.0
    coord5 := Coordinate -1.0 0.0
    bearing := coord1.bearingTo coord5
    if bearing != 180.0:
        print "❌ Expected 180.0, got $bearing"
    else:
        print "✅ testBearingToSouth passed"

testBearingTo45:
    coord1 := Coordinate 0.0 0.0
    coord6 := Coordinate 1.0 1.0
    bearing := FixedPoint (coord1.bearingTo coord6) --decimals=0
    if bearing != 45.0:
        print "❌ Expected 45.0, got $bearing"
    else:
        print "✅ testBearingTo45 passed"

testdistanceToPolygonEdge:
  boundary := [
    Coordinate 0.0 0.0,
    Coordinate 0.0 1.0,
    Coordinate 1.0 1.0,
    Coordinate 1.0 0.0
  ]
  insideCoord := Coordinate 0.5 (1.0 - 0.0000899) // 10m from the edge, half way up
  outsideCoord := Coordinate 0.5 1.0000899 // 10m from the edge, half way up

  distanceInside := insideCoord.distanceToPolygonEdge boundary
  distanceInsideFixed := (FixedPoint distanceInside --decimals=2)
  if distanceInsideFixed != 10:
      print "❌ testdistanceToPolygonEdge Expected 10, got $distanceInsideFixed"
  else:
      print "✅ testdistanceToPolygonEdge (inside) passed"
  
  distanceOutside := outsideCoord.distanceToPolygonEdge boundary
  distanceOutsideFixed := (FixedPoint distanceOutside --decimals=2)
  if distanceOutsideFixed != 10:
      print "❌ testdistanceToPolygonEdge Expected 10, got $distanceOutsideFixed"
  else:
      print "✅ testdistanceToPolygonEdge (outside) passed"

testdistanceToPolygon:
  boundary := [
    Coordinate 0.0 0.0,
    Coordinate 0.0 1.0,
    Coordinate 1.0 1.0,
    Coordinate 1.0 0.0
  ]
  insideCoord := Coordinate 0.5 0.5 // middle
  outsideCoord := Coordinate 0.5 1.0000899 // 10m from the edge, half way up

  distanceInside := insideCoord.distanceToPolygon boundary
  if distanceInside != 0.0:
    print "❌ testdistanceToPolygon Expected 0.0, got $distanceInside"
  else:
    print "✅ testdistanceToPolygon (inside) passed"

  distanceOutside := outsideCoord.distanceToPolygon boundary
  distanceOutsideFixed := (FixedPoint distanceOutside --decimals=2)
  if distanceOutsideFixed != 10:
    print "❌ testdistanceToPolygon Expected 10, got $distanceOutsideFixed"
  else:
    print "✅ testdistanceToPolygon (outside) passed"