import Foundation

public enum Day12: Advent {
    public static func firstStar(for input: String) {
        let lines = input.components(separatedBy: .newlines).compactMap { arrangements(for: $0) }
        let sum = lines.reduce(0, +)
        print("SUM: \(sum)")
    }

    public static func secondStar(for input: String) {}
}

// MARK: - Private

private extension Day12 {
    static var dot = "."
    static var sharp = "#"

    enum Quantifier {
        case oneOrMore
        case zeroOrMore
        case exactly(count: Int)
    }

    enum Spring {
        case damaged
        case operational
        case unowned
    }

    // MARK: - Common

    static func pattern(for spring: Spring, quantifier: Quantifier) -> String {
        return springPattern(for: spring) + quantifierPattern(for: quantifier)
    }

    static func quantifierPattern(for quantifier: Quantifier) -> String {
        switch quantifier {
        case.oneOrMore: return "+"
        case.zeroOrMore: return "*"
        case .exactly(count: let count): return "{\(count)}"
        }
    }

    static func springPattern(for spring: Spring) -> String {
        switch spring {
        case .damaged: return "\\#"
        case .operational: return "\\."
        case .unowned: return "."
        }
    }

    static func regex(for contiguousGroupsOfDamagedSprings: [Int]) -> Regex<Substring>? {
        guard !contiguousGroupsOfDamagedSprings.isEmpty else { return nil }
        let separatorPattern = pattern(for: .operational, quantifier: .oneOrMore)
        let damagedSpringsPattern: (Int) -> String = { count in
            pattern(for: .damaged, quantifier: .exactly(count: count))
        }
        let regexForContiguousGroupsOfDamagedSprings = contiguousGroupsOfDamagedSprings
            .map { damagedSpringsPattern($0) }
            .joined(separator: separatorPattern)
        let operationalSpringsPattern = pattern(for: .operational, quantifier: .zeroOrMore)
        return try? Regex(operationalSpringsPattern + regexForContiguousGroupsOfDamagedSprings + operationalSpringsPattern)
    }

    static func parts(for contiguousGroupsOfDamagedSprings: [Int], countOfAllSprings: Int) -> [String] {
        guard !contiguousGroupsOfDamagedSprings.isEmpty else { return Array(repeating: dot, count: countOfAllSprings) }

        let groupsOfDamagedSprings = zip(
            contiguousGroupsOfDamagedSprings.map { String(repeating: sharp, count: $0) },
            Array(repeating: dot, count: contiguousGroupsOfDamagedSprings.count - 1) + [""]
        ).map { $0 + $1 }

        let dotCount = countOfAllSprings - contiguousGroupsOfDamagedSprings.reduce(0, +) - (contiguousGroupsOfDamagedSprings.count - 1)
        let dots = Array(repeating: dot, count: dotCount)

        return groupsOfDamagedSprings + dots
    }

    static func regex(for input: String) -> Regex<Substring>? {
        var regex = "\\A"
        for char in input {
            switch char {
            case ".": regex += pattern(for: .operational, quantifier: .exactly(count: 1))
            case "#": regex += pattern(for: .damaged, quantifier: .exactly(count: 1))
            default: regex += pattern(for: .unowned, quantifier: .exactly(count: 1))
            }
        }
        return try? Regex(regex)
    }

    // MARK: - First star

    static func arrangements(for input: String) -> Int? {
        guard !input.isEmpty else { return nil }
        let components = input.components(separatedBy: .whitespaces)
        guard let input = components.first,
              let counts = components.last?.components(separatedBy: ",").compactMap({ Int($0) }),
              let countRegex = regex(for: counts), let inputRegex = regex(for: input) else { return nil }
        let parts = parts(for: counts, countOfAllSprings: input.count)
        let permutations: Set<String> = Set(parts.uniquePermutations(ofCount: parts.count).map { $0.joined() })
        let result = permutations.filter { $0.contains(inputRegex) && $0.contains(countRegex) }
        return result.count
    }
}
