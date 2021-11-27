require_relative "util" 
require 'xmlsimple'

xml = XmlSimple.xml_in("waypoints_2021_11_26_16_36_31.gpx")

waypoints = xml["wpt"]

print "Base waypoint:\n"
waypoints.each_index { |index| print "    #{index + 1}: #{waypoints[index]['name'][0]}\n" }
print " select (1 - #{waypoints.size}): "
baseWaypointIndex = readline.chomp.to_i
abort if baseWaypointIndex < 1 || baseWaypointIndex >= waypoints.size
baseWaypoint = waypoints[baseWaypointIndex - 1]

baseLat = dToR(baseWaypoint["lat"].to_f)
baseLon = dToR(baseWaypoint["lon"].to_f)

print "Course (1 - #{$courses.size}): "
courseIndex = readline.chomp.to_i
abort if courseIndex < 1 || courseIndex >= $courses.size
course = $courses[courseIndex - 1]
distances = course[0]
buoyNames = course[1]
angles = course[2]

print "Wind direction: "
windDirection = readline.chomp.to_f
abort if windDirection < 0 || windDirection >= 360
windDirection = dToR(windDirection)
print "Wind speed (kts): "
windSpeed = readline.chomp.to_i
abort if windSpeed < 4 || windSpeed > 20
windSpeedIndex = (windSpeed - 4) / 2

print "\n\n"

def calcPosition(name, buoys, distances, angles, windDirection, windSpeedIndex)
    if name == "div51"
        name = "1"
        distFactor = 0.67
    elsif name == "div52"
        name = "3"
        distFactor = 0.67
    else
        distFactor = 1.0
    end
    buoys.each { |buoy|
        dist = distances.fetch(("d" + buoy.name + name).to_sym, nil)
        next if dist.nil?
        ang = dToR(angles[("a" + buoy.name + name).to_sym]) + windDirection
        return project(buoy.lat, buoy.lon, ang, dist[windSpeedIndex] / 1000.0 * distFactor)
    }
    return nil, nil
end

buoys = []
buoyNames.each { |buoy|
    name = buoy.to_s.delete_prefix("b")
    buoys << (buoy == :b4 ? Buoy.new(name, baseLat, baseLon) : Buoy.new(name, *calcPosition(name, buoys, distances, angles, windDirection, windSpeedIndex)))
}

buoys.each { |buoy|
    next if buoy.name == "4"
    
    newBuoy = baseWaypoint.dup
    newBuoy["name"] = ["Buoy #{buoy.name}"]
    newBuoy["lat"] = rToD(buoy.lat).to_s
    newBuoy["lon"] = rToD(buoy.lon).to_s
    xml["wpt"] << newBuoy
}

xmlData = XmlSimple.xml_out(xml, OutputFile: "wp.gpx", RootName: "gpx", XmlDeclaration: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
