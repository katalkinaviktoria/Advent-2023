import Foundation

public enum Day10: Advent {

    public static func firstStar(for input: String) {
        let count = boundaryPoints(from: input, process: { _ in })
        print("COUNT: \(count)")
    }

    public static func secondStar(for input: String) {
        var points: [SIMD2<Int>] = []
        let borderCount = boundaryPoints(from: input, process: { point in points.append(point) })
        let interiorCount = polygonArea(points: points) + 1 - borderCount
        print("Count: \(interiorCount)")
    }
}

// MARK: - Private

private extension Day10 {

    enum Direction: Hashable, CaseIterable {
        case north
        case south
        case east
        case west

        var opposite: Direction {
            switch self {
            case .north: return .south
            case .south: return .north
            case .east: return .west
            case .west: return .east
            }
        }
    }

    // MARK: - Common

    static func boundaryPoints(from input: String, process: (SIMD2<Int>) -> Void) -> Int {
        var map: [SIMD2<Int>: Set<Direction>] = [:]
        var x = 0
        var y = 1
        var start: SIMD2<Int>?

        for char in input {
            guard !char.isNewline else {
                y += 1
                x = 0
                continue
            }

            x += 1
            let coordinate = SIMD2<Int>(x: x, y: y)

            guard char != "S" else {
                start = coordinate
                continue
            }

            map[coordinate] = directions(for: char)
        }

        guard let start else {
            assertionFailure("Start point not found")
            return 0
        }

        var startCoordinate: SIMD2<Int>?
        var startDirection: Direction?

        Direction.allCases.forEach { direction in
            let coordinate = coordinate(for: start, to: direction)
            if let directions = map[coordinate],
                directions.contains(direction),
                let from = directions.intersection([direction]).first {
                startCoordinate = coordinate
                startDirection = from
            }
        }

        guard var startCoordinate, var startDirection else {
            assertionFailure("Start position not found")
            return 0
        }

        var steps = 0

        process(startCoordinate)

        while startCoordinate != start {
            guard let to = nextDirection(from: startDirection, point: startCoordinate, map: map) else {
                print("Next direction not found")
                return 0
            }

            steps += 1

            startCoordinate = coordinate(for: startCoordinate, to: to.opposite)
            startDirection = to.opposite

            process(startCoordinate)
        }

        return (steps + 1) / 2
    }

    static func directions(for pipe: Character) -> Set<Direction> {
        switch pipe {
        case "|": return [.south, .north]
        case "-": return [.east, .west]
        case "L": return [.west, .south]
        case "J": return [.east, .south]
        case "F": return [.north, .west]
        case "7": return [.north, .east]
        default: return []
        }
    }

    static func coordinate(for point: SIMD2<Int>, to direction: Direction) -> SIMD2<Int> {
        switch direction {
        case .east: return SIMD2<Int>(x: 1, y: 0) &+ point
        case .west: return SIMD2<Int>(x: -1, y: 0) &+ point
        case .north: return SIMD2<Int>(x: 0, y: -1) &+ point
        case .south: return SIMD2<Int>(x: 0, y: 1) &+ point
        }
    }

    static func nextDirection(from: Direction, point: SIMD2<Int>, map: [SIMD2<Int>: Set<Direction>]) -> Direction? {
        let directions = map[point]
        let availableDirections = directions?.subtracting(Set([from]))
        return availableDirections?.first
    }

    // MARK: - Second star

    static func polygonArea(points: [SIMD2<Int>]) -> Int {
        var area = 0
        var j = points.count - 1

        for i in 0..<points.count {
            let point1 = points[i]
            let point2 = points[j]
            area +=  (point2.x + point1.x) * (point2.y - point1.y)
            j = i
        }

        return area / 2
    }
}
