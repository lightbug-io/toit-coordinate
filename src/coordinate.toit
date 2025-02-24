import math
import fixed-point show FixedPoint

// A constant representing an invalid or infinite distance.
INFINITY_DISTANCE := -1.0

// Earth's radius in meters, used for distance calculations assuming a spherical Earth.
EARTH_RADIUS := 6371e3 

class Coordinate:
    lat/float  // Latitude in degrees.
    lon/float  // Longitude in degrees.

    /*
    Initializes a Coordinate with the given latitude and longitude.
    */
    constructor latitude/float longitude/float:
      lat = latitude
      lon = longitude

    /*
    Computes the great-circle distance (Haversine formula) between two coordinates.
    Assumes the Earth is a perfect sphere.
    Returns distance in meters.
    */
    distanceToCoord other/Coordinate -> float:
      phi1 := lat * math.PI / 180 // Convert degrees to radians
      phi2 := other.lat * math.PI / 180
      dphi := (other.lat - lat) * math.PI / 180
      dlam := (other.lon - lon) * math.PI / 180

      a := (math.sin dphi / 2) * (math.sin dphi / 2) + (math.cos phi1) * (math.cos phi2) * (math.sin dlam / 2) * (math.sin dlam / 2)
      c := 2 * (math.atan2 (math.sqrt a) (math.sqrt 1 - a))

      return abs EARTH_RADIUS * c
    
    /*
    Checks if the current coordinate is within a given radius of a center coordinate.
    Uses the great-circle distance for calculation.
    */
    inCircle center/Coordinate radius/float -> bool:
      return (distanceToCoord center) <= radius
    
    /*
    Determines if the current coordinate is inside a polygon defined by a list of coordinates.
    Uses the ray-casting algorithm, assuming a simple, non-self-intersecting polygon.
    The polygon's edges should be defined in order (clockwise or counterclockwise).
    */
    inPolygon boundary/List -> bool:
      x := lon
      y := lat
      n := boundary.size
      inside := false
      j := n - 1 // Last vertex
      
      for i := 0; i < n; i += 1:
        xi := boundary[i].lon
        yi := boundary[i].lat
        xj := boundary[j].lon
        yj := boundary[j].lat
        
        // Check if the ray crosses the edge
        intersect := ((yi > y) != (yj > y)) and (x < (xj - xi) * (y - yi) / (yj - yi) + xi)
        if intersect:
          inside = not inside
        
        j = i // Move to next edge
      
      return inside

    /*
    Computes the perpendicular distance from the current coordinate to a line segment (p1, p2).
    Uses the great-circle distance and bearings to estimate this distance.
    */
    distanceToLine p1/Coordinate p2/Coordinate -> float:
      ax := distanceToCoord p1
      alpha := (abs ((p1.bearingTo p2) - (p1.bearingTo this))) / 180 * math.PI // Convert degrees to radians
      return abs (math.sin alpha) * ax // Compute perpendicular distance

    /*
    Computes the shortest distance from the current coordinate to any edge of a polygon.
    Uses the `distanceToLine` method to measure distance to each edge.
    */
    distanceToPolygonEdge boundary/List -> float:
      minDistance/float := INFINITY_DISTANCE
      n := boundary.size
      
      for i := 0; i < n; i += 1:
        p1 := boundary[i]
        p2 := boundary[(i + 1) % n] // Wraps around to connect last and first vertex
        distance := distanceToLine p1 p2
        
        if (distance < minDistance) or (minDistance == INFINITY_DISTANCE):
          minDistance = distance
      
      return minDistance
    
    /*
    Computes the shortest distance from the current coordinate to a polygon.
    If inside, returns 0. Otherwise, returns the shortest distance to an edge.
    */
    distanceToPolygon boundary/List -> float:
      if inPolygon boundary:
        return 0.0
      return distanceToPolygonEdge boundary

    /*
    Computes the initial bearing (forward azimuth) from the current coordinate to another coordinate.
    Assumes a spherical Earth and uses trigonometry to compute the bearing in degrees.
    */
    bearingTo other/Coordinate -> float:
      dLon := (other.lon - lon) * math.PI / 180
      lat1 := lat * math.PI / 180
      lat2 := other.lat * math.PI / 180
      y := (math.sin dLon) * (math.cos lat2)
      x := (math.cos lat1) * (math.sin lat2) - (math.sin lat1) * (math.cos lat2) * (math.cos dLon)
      return (math.atan2 y x) * 180 / math.PI // Convert radians to degrees

/*
Returns the absolute value of a float.
*/
abs value/float -> float:
  if value < 0:
    return -value
  return value
