def dToR(d)
    return d / 180.0 * Math::PI
end

def rToD(r)
    return r / Math::PI * 180.0
end

Radius = 6371.0    # earth's radius in km

def project(lat, lon, direction, distance)
    newLat = Math.asin(Math.sin(lat) * Math.cos(distance / Radius) + Math.cos(lat) * Math.sin(distance / Radius) * Math.cos(direction))
    newLon = lon + Math.atan2(Math.sin(direction) * Math.sin(distance / Radius) * Math.cos(lat), Math.cos(distance / Radius) - Math.sin(lat) * Math.sin(newLat))
    return newLat, newLon
end

distances1 = {
    d41: [ 350, 450, 550, 650, 750, 850, 1050, 1100, 1150 ],
    d12: [  80, 100, 120, 150, 170, 190,  240,  250,  260 ],
    d45: [ 390, 500, 610, 720, 830, 940, 1170, 1220, 1270 ],
    d43: [ 250, 320, 390, 460, 530, 600,  740,  780,  810 ],
    d2H: [ 100, 100, 100, 100, 100, 100,  100,  100,  100 ],
}

buoys1 = [ :b4, :b1, :b2, :bH, :b5, :b3, :bdiv51, :bdiv52 ]

angles1 = { a41: 0, a4div51: 0, a12: 0, a45: 300, a2H: 235, a43: 315, a4div52: 315 }

# fix all these
distances2 = {
    d41: [ 350, 450, 550, 650, 750, 850, 1050, 1100, 1150 ],
    d12: [  80, 100, 120, 150, 170, 190,  240,  250,  260 ],
    d25: [ 410, 530, 640, 760, 880, 990, 1230, 1290, 1350 ],
    d43: [ 250, 320, 390, 460, 530, 600,  740,  780,  810 ],
    d2H: [ 100, 100, 100, 100, 100, 100,  100,  100,  100 ],
}

buoys2 = [ :b4, :b1, :b2, :bH, :b5, :b3, :bdiv51, :bdiv52 ]

angles2 = { a41: 0, a4div51: 0, a12: 0, a45: 300, a2H: 235, a43: 315, a4div52: 315 }

$courses = [
    [ distances1, buoys1, angles1 ],
    [ distances2, buoys2, angles2 ]
]

Buoy = Struct.new(:name, :lat, :lon)

