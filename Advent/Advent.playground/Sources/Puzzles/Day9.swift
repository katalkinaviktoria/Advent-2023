import Foundation

public enum Day9: Advent {
    public static func firstStar(for input: String) {
        let extrapolate: ([Int], Int) -> Int = { numbers, a in (numbers.last ?? 0) + a }
        sumOfExtrapolatedValue(from: input, extrapolate: extrapolate)
    }

    public static func secondStar(for input: String) {
        let extrapolate: ([Int], Int) -> Int = { numbers, a in (numbers.first ?? 0) - a }
        sumOfExtrapolatedValue(from: input, extrapolate: extrapolate)
    }
}

// MARK: - Private

private extension Day9 {

    // MARK: - Common

    static func sumOfExtrapolatedValue(from input: String, extrapolate: ([Int], Int) -> Int) {
        let numbers: (String) -> [Int] = { $0.components(separatedBy: .whitespaces).compactMap { Int($0) } }
        let sum = input.components(separatedBy: .newlines).reduce(0) { $0 + extrapolatedValue(for: numbers($1),
                                                                                              extrapolate: extrapolate) }
        print("SUM: \(sum)")
    }

    static func extrapolatedValue(for numbers: [Int], extrapolate: ([Int], Int) -> Int) -> Int {
        guard numbers.contains(where: { $0 != 0 }) else { return 0 }
        let nextNumbers = difference(for: numbers, startIndex: 0)
        return extrapolate(numbers, extrapolatedValue(for: nextNumbers, extrapolate: extrapolate))
    }

    static func difference(for numbers: [Int], startIndex: Int) -> [Int] {
        guard startIndex < numbers.count - 1 else { return [] }

        let number = numbers[startIndex]
        let nextNumber = numbers[startIndex + 1]
        let differenceNumber = nextNumber - number

        var differenceNumbers = [differenceNumber]
        differenceNumbers.append(contentsOf: difference(for: numbers, startIndex: startIndex + 1))

        return differenceNumbers
    }
}
