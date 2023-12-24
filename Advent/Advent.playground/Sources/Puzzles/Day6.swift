import Foundation

public enum Day6: Advent {
    public static func firstStar(for input: String) {
        numberOfWinningWays(from: input) { $0.components(separatedBy: .whitespaces) }
    }

    public static func secondStar(for input: String) {
        numberOfWinningWays(from: input) { [$0.components(separatedBy: .whitespaces).joined()] }
    }
}

// MARK: - Private

private extension Day6 {

    // MARK: - Common

    static func numberOfWinningWays(from input: String, components: (Substring) -> [String]) {
        let regex = /Time:(?<times>(\s+\d+)+)\nDistance:(?<distances>(\s+\d+)+)/
        let match = input.firstMatch(of: regex)?.output
        guard let timeInput = match?.times, let distanceInput = match?.distances else {
            assertionFailure("Input is incorrect")
            return
        }

        let times = components(timeInput).compactMap( { Double($0) })
        let distances = components(distanceInput).compactMap( { Double($0) })

        let sum = zip(times, distances).reduce(1) { $0 * numberOfWaysToBeat(time: $1.0, distance: $1.1)}
        print("SUM: \(sum)")
    }

    static func numberOfWaysToBeat(time: Double, distance: Double) -> Int {
        let discriminant = discriminant(a: 1, b: -1 * time, c: distance)
        let roots = roots(a: 1, b: -1 * time, discriminant: discriminant)
        let down = Int(roots.x1.rounded(.up))
        let up = Int(roots.x2.rounded(.down))
        return up - down + 1
    }

    static func discriminant(a: Double, b: Double, c: Double) -> Double {
        sqrt(pow(b, 2) - 4 * a * c)
    }

    static func roots(a: Double, b: Double, discriminant: Double) -> (x1: Double, x2: Double) {
        let x1 = (-1 * b - discriminant) / 2 * a
        let x2 = (-1 * b + discriminant) / 2 * a
        return (x1, x2)
    }
}
