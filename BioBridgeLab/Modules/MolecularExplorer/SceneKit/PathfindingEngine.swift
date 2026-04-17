import SceneKit

struct Waypoint {
    let position: SCNVector3
    let isStop: Bool
    let stopIndex: Int?
}

class PathfindingEngine {
    let waypoints: [Waypoint]
    let stops: [EducationalStop]

    init(stops: [EducationalStop]) {
        self.stops = stops
        var result: [Waypoint] = []

        for (i, stop) in stops.enumerated() {
            // Add intermediate waypoints between stops for smooth walking
            if i > 0 {
                let prev = stops[i - 1]
                let intermediates = PathfindingEngine.interpolate(from: prev.position, to: stop.position, steps: 4)
                for pt in intermediates {
                    result.append(Waypoint(position: pt, isStop: false, stopIndex: nil))
                }
            }
            result.append(Waypoint(position: stop.position, isStop: true, stopIndex: i))
        }

        self.waypoints = result
    }

    /// Get the full path from one stop to the next
    func pathBetweenStops(from: Int, to: Int) -> [SCNVector3] {
        guard from < stops.count, to < stops.count else { return [] }

        let fromPos = stops[from].position
        let toPos = stops[to].position

        // Generate smooth intermediate points
        var path = [fromPos]
        let intermediates = PathfindingEngine.interpolate(from: fromPos, to: toPos, steps: 6)
        path.append(contentsOf: intermediates)
        path.append(toPos)

        return path
    }

    /// Direct path from current position to a stop
    func pathToStop(_ stopIndex: Int, from currentPosition: SCNVector3) -> [SCNVector3] {
        guard stopIndex < stops.count else { return [] }
        let destination = stops[stopIndex].position
        var path: [SCNVector3] = []

        let intermediates = PathfindingEngine.interpolate(from: currentPosition, to: destination, steps: 4)
        path.append(contentsOf: intermediates)
        path.append(destination)

        return path
    }

    /// Linear interpolation with slight curve for natural-looking movement
    private static func interpolate(from: SCNVector3, to: SCNVector3, steps: Int) -> [SCNVector3] {
        guard steps > 0 else { return [] }
        var result: [SCNVector3] = []

        for i in 1..<steps {
            let t = Float(i) / Float(steps)
            // Smooth step interpolation
            let smoothT = t * t * (3.0 - 2.0 * t)

            let x = from.x + (to.x - from.x) * smoothT
            let y = from.y + (to.y - from.y) * smoothT
            let z = from.z + (to.z - from.z) * smoothT

            // Add slight arc to the path (rise then fall)
            let arcHeight: Float = 0.15 * sin(Float.pi * t)
            result.append(SCNVector3(x, y + arcHeight, z))
        }

        return result
    }
}
