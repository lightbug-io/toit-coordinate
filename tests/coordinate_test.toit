import coordinate show Coordinate
import fixed-point show FixedPoint

main:
    test-distance-to-coord
    test-distance-to-coord-1km
    test-distance-to-coord-100km
    test-distance-to-coord-negative-coords
    test-in-circle
    test-in-polygon
    test-complex-polygon
    test-distance-to-line
    test-bearing-to
    test-distance-to-polygon-edge
    test-distance-to-polygon

test-distance-to-coord:
    coord1 := Coordinate 0.0 0.0
    coord2 := Coordinate 0.0000899 0.0
    distance := coord1.distance-to-coord coord2
    if distance != 9.996423905345830363:
        print "❌ Expected 9.996423905345830363, got $distance"
    else:
        print "✅ test-distance-to-coord passed"

test-distance-to-coord-1km:
    coord1 := Coordinate 0.0 0.0
    coord2 := Coordinate 0.00899 0.0
    distance := coord1.distance-to-coord coord2
    if distance != 999.64239053458311446:
        print "❌ Expected 999.64239053458311446, got $distance"
    else:
        print "✅ test-distance-to-coord-1km passed"

test-distance-to-coord-100km:
    coord1 := Coordinate 0.0 0.0
    coord2 := Coordinate 0.899 0.0
    distance := coord1.distance-to-coord coord2
    if distance != 99964.239053458311446:
        print "❌ Expected 99964.239053458311446, got $distance"
    else:
        print "✅ test-distance-to-coord-100km passed"

test-distance-to-coord-negative-coords:
    coord1 := Coordinate 0.0 0.0
    coord2 := Coordinate -0.00899 0.0
    distance := coord1.distance-to-coord coord2
    if distance != 999.64239053458311446:
        print "❌ Expected 999.64239053458311446, got $distance"
    else:
        print "✅ test-distance-to-coord-negative-coords passed"

test-in-circle:
    center := Coordinate 0.0 0.0
    insideCoord := Coordinate 0.0000899 0.0
    outsideCoord := Coordinate 0.01 0.0
    radius := 10.0

    if not (insideCoord.in-circle center radius):
        print "❌ Expected insideCoord to be inside the circle"
    else:
        print "✅ test-in-circle (inside) passed"

    if outsideCoord.in-circle center radius:
        print "❌ Expected outsideCoord to be outside the circle"
    else:
        print "✅ test-in-circle (outside) passed"

test-in-polygon:
    boundary := [
      Coordinate 0.0 0.0,
      Coordinate 0.0 1.0,
      Coordinate 1.0 1.0,
      Coordinate 1.0 0.0
    ]
    insideCoord := Coordinate 0.5 0.5
    outsideCoord := Coordinate 1.5 1.5

    if not (insideCoord.in-polygon boundary):
        print "❌ Expected insideCoord to be inside the polygon"
    else:
        print "✅ test-in-polygon (inside) passed"

    if outsideCoord.in-polygon boundary:
        print "❌ Expected outsideCoord to be outside the polygon"
    else:
        print "✅ test-in-polygon (outside) passed"

test-complex-polygon:
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
      if not (coord.in-polygon boundary):
        print "❌ Expected $coord to be inside the polygon"
      else:
        print "✅ test-complex-polygon (inside) passed"

    outsideCoords.do: |coord|
      if coord.in-polygon boundary:
        print "❌ Expected $coord to be outside the polygon"
      else:
        print "✅ test-complex-polygon (outside) passed"

test-distance-to-line:
  test-distance-to-line-on-p1
  test-distance-to-line-on-p2
  test-distance-to-line-on-10m-from-p1
  test-distance-to-line-on-10m-from-p2
  test-distance-to-line-10m-from-middle
  test-distance-to-line-10m-from-middle-other-side

test-distance-to-line-on-p1:
  p1 := Coordinate 0.0 0.0
  p2 := Coordinate 0.1 0.0
  coord := Coordinate 0.1 0.0 // On the line, at the point 2
  distance := coord.distance-to-line p1 p2
  if distance != 0.0:
      print "❌ test-distance-to-line-on-p1 Expected 0.0, got $distance"
  else:
      print "✅ test-distance-to-line-on-p1 passed"

test-distance-to-line-on-p2:
  p1 := Coordinate 0.0 0.0
  p2 := Coordinate 0.1 0.0
  coord := Coordinate 0.0 0.0 // On the line, at the point 1
  distance := coord.distance-to-line p1 p2
  if distance != 0.0:
      print "❌ test-distance-to-line-on-p2 Expected 0.0, got $distance"
  else:
      print "✅ test-distance-to-line-on-p2 passed"

test-distance-to-line-on-10m-from-p1:
  p1 := Coordinate 0.0 0.0
  p2 := Coordinate 0.1 0.0
  coord := Coordinate 0.1 0.0000899 // 10m from the line, at the point 2
  distance := coord.distance-to-line p1 p2
  distanceFixed := (FixedPoint distance --decimals=2)
  if distanceFixed != 10.0:
      print "❌ test-distance-to-line-on-10m-from-p1 Expected 10.0, got $distanceFixed"
  else:
      print "✅ test-distance-to-line-on-10m-from-p1 passed"

test-distance-to-line-on-10m-from-p2:
  p1 := Coordinate 0.0 0.0
  p2 := Coordinate 0.1 0.0
  coord := Coordinate 0.0 0.0000899 // 10m from the line, at the point 1
  distance := coord.distance-to-line p1 p2
  distanceFixed := (FixedPoint distance --decimals=2)
  if distanceFixed != 10.0:
      print "❌ test-distance-to-line-on-10m-from-p2 Expected 10.0, got $distanceFixed"
  else:
      print "✅ test-distance-to-line-on-10m-from-p2 passed"

test-distance-to-line-10m-from-middle:
  p1 := Coordinate 0.0 0.0
  p2 := Coordinate 1.0 0.0
  coord := Coordinate 0.5 0.0000899 // 10m from the line, in the middle
  distance := coord.distance-to-line p1 p2
  distanceFixed := (FixedPoint distance --decimals=0)
  if distanceFixed != 10.0:
      print "❌ test-distance-to-line-10m-from-middle Expected 10.0, got $distanceFixed"
  else:
      print "✅ test-distance-to-line-10m-from-middle passed"

test-distance-to-line-10m-from-middle-other-side:
  p1 := Coordinate 0.0 0.0
  p2 := Coordinate 1.0 0.0
  coord := Coordinate 0.5 -0.0000899 // 10m from the line, in the middle
  distance := coord.distance-to-line p1 p2
  distanceFixed := (FixedPoint distance --decimals=0)
  if distanceFixed != 10.0:
      print "❌ test-distance-to-line-10m-from-middle-other-side Expected 10.0, got $distanceFixed"
  else:
      print "✅ test-distance-to-line-10m-from-middle-other-side passed"

test-bearing-to:
    test-bearing-to-east
    test-bearing-to-north
    test-bearing-to-west
    test-bearing-to-south
    test-bearing-to-45

test-bearing-to-east:
    coord1 := Coordinate 0.0 0.0
    coord2 := Coordinate 0.0 1.0
    bearing := coord1.bearing-to coord2
    if bearing != 90.0:
        print "❌ Expected 90.0, got $bearing"
    else:
        print "✅ test-bearing-to-east passed"

test-bearing-to-north:
    coord1 := Coordinate 0.0 0.0
    coord3 := Coordinate 1.0 0.0
    bearing := coord1.bearing-to coord3
    if bearing != 0.0:
        print "❌ Expected 0.0, got $bearing"
    else:
        print "✅ test-bearing-to-north passed"

test-bearing-to-west:
    coord1 := Coordinate 0.0 0.0
    coord4 := Coordinate 0.0 -1.0
    bearing := coord1.bearing-to coord4
    if bearing != -90.0:
        print "❌ Expected -90.0, got $bearing"
    else:
        print "✅ test-bearing-to-west passed"

test-bearing-to-south:
    coord1 := Coordinate 0.0 0.0
    coord5 := Coordinate -1.0 0.0
    bearing := coord1.bearing-to coord5
    if bearing != 180.0:
        print "❌ Expected 180.0, got $bearing"
    else:
        print "✅ test-bearing-to-south passed"

test-bearing-to-45:
    coord1 := Coordinate 0.0 0.0
    coord6 := Coordinate 1.0 1.0
    bearing := FixedPoint (coord1.bearing-to coord6) --decimals=0
    if bearing != 45.0:
        print "❌ Expected 45.0, got $bearing"
    else:
        print "✅ test-bearing-to-45 passed"

test-distance-to-polygon-edge:
  boundary := [
    Coordinate 0.0 0.0,
    Coordinate 0.0 1.0,
    Coordinate 1.0 1.0,
    Coordinate 1.0 0.0
  ]
  insideCoord := Coordinate 0.5 (1.0 - 0.0000899) // 10m from the edge, half way up
  outsideCoord := Coordinate 0.5 1.0000899 // 10m from the edge, half way up

  distanceInside := insideCoord.distance-to-polygon-edge boundary
  distanceInsideFixed := (FixedPoint distanceInside --decimals=2)
  if distanceInsideFixed != 10:
      print "❌ test-distance-to-polygon-edge Expected 10, got $distanceInsideFixed"
  else:
      print "✅ test-distance-to-polygon-edge (inside) passed"
  
  distanceOutside := outsideCoord.distance-to-polygon-edge boundary
  distanceOutsideFixed := (FixedPoint distanceOutside --decimals=2)
  if distanceOutsideFixed != 10:
      print "❌ test-distance-to-polygon-edge Expected 10, got $distanceOutsideFixed"
  else:
      print "✅ test-distance-to-polygon-edge (outside) passed"

test-distance-to-polygon:
  boundary := [
    Coordinate 0.0 0.0,
    Coordinate 0.0 1.0,
    Coordinate 1.0 1.0,
    Coordinate 1.0 0.0
  ]
  insideCoord := Coordinate 0.5 0.5 // middle
  outsideCoord := Coordinate 0.5 1.0000899 // 10m from the edge, half way up

  distanceInside := insideCoord.distance-to-polygon boundary
  if distanceInside != 0.0:
    print "❌ test-distance-to-polygon Expected 0.0, got $distanceInside"
  else:
    print "✅ test-distance-to-polygon (inside) passed"

  distanceOutside := outsideCoord.distance-to-polygon boundary
  distanceOutsideFixed := (FixedPoint distanceOutside --decimals=2)
  if distanceOutsideFixed != 10:
    print "❌ test-distance-to-polygon Expected 10, got $distanceOutsideFixed"
  else:
    print "✅ test-distance-to-polygon (outside) passed"