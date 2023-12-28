import Foundation
import Algorithms

public enum Day11: Advent {
    public static func firstStar(for input: String) {
        sumOfLengths(from: input, multiplier: 2)
    }

    public static func secondStar(for input: String) {
        sumOfLengths(from: input, multiplier: 1_000_000)
    }
}

// MARK: - Private

private extension Day11 {

    // MARK: - Common

    static func sumOfLengths(from input: String, multiplier: Int) {
        var x = 0
        var y = 1

        var xMap: Set<Int> = []
        var yMap: Set<Int> = [1]

        var galaxies: Set<SIMD2<Int>> = []

        for char in input {
            guard !char.isNewline else {
                y += 1
                x = 0

                yMap.insert(y)
                continue
            }

            x += 1

            if y == 1 { xMap.insert(x) }

            if char == "#" {
                xMap.remove(x)
                yMap.remove(y)

                galaxies.insert(SIMD2<Int>(x: x, y: y))
            }
        }

        let sum = galaxies.combinations(ofCount: 2).reduce(0) { result, combination in
            let point1 = combination[0]
            let point2 = combination[1]

            let extendedX = countOfNumberInRange(n1: point1.x, n2: point2.x, from: xMap)
            let extendedY = countOfNumberInRange(n1: point1.y, n2: point2.y, from: yMap)

            let vector = combination[0] &- combination[1]
            let length = abs(vector.x) + abs(vector.y) + (multiplier - 1) * (extendedX + extendedY)

            return result + length
        }

        print("SUM: \(sum)")
    }

    static func countOfNumberInRange(n1: Int, n2: Int, from set: Set<Int>) -> Int {
        let range = n1 > n2 ? n2...n1 : n1...n2
        return set.filter { range.contains($0) }.count
    }
}
