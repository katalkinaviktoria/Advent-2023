import Foundation

public enum Day2: Advent {
    public static func firstStar(for input: String) {
        sumOfGames(from: input, process: possibleGameID)
    }

    public static func secondStar(for input: String) {
        sumOfGames(from: input, process: powerOfGame)
    }
}

// MARK: - Private

private extension Day2 {

    enum Color: String, CaseIterable {
        case red
        case green
        case blue

        var countRegex: Regex<(Substring, count: Substring)> {
            switch self {
            case .red: return /(?<count>\d+) red/
            case .green: return /(?<count>\d+) green/
            case .blue: return /(?<count>\d+) blue/
            }
        }

        var maxCount: Int {
            switch self {
            case .red: return 12
            case .green: return 13
            case .blue: return 14
            }
        }
    }

    // MARK: - Common

    static func sumOfGames(from input: String,
                           process: (Regex<(Substring, game: Substring, details: Substring)>.Match) -> Int?) {
        let gameRegex = /Game (?<game>\d+):(?<details>.*)/
        let games = input.matches(of: gameRegex).compactMap { process($0) }
        let sum = games.reduce(0, +)
        print("SUM: \(sum)")
    }

    // MARK: - First star

    static func possibleGameID(from match: Regex<(Substring, game: Substring, details: Substring)>.Match) -> Int? {
        guard Color.allCases.reduce(true, { $0 && validate(match.output.details, for: $1) }) else { return nil }
        return Int(String(match.output.game))
    }

    static func validate(_ input: Substring, for color: Color) -> Bool {
        !input.matches(of: color.countRegex).contains(where: { result in
            guard let current = Int(result.output.count) else { return false }
            return current > color.maxCount
        })
    }

    // MARK: - Second star

    static func powerOfGame(from match: Regex<(Substring, game: Substring, details: Substring)>.Match) -> Int? {
        Color.allCases.reduce(1) { $0 * validate(max(from: match.output.details, for: $1.countRegex), for: $1) }
    }

    static func max(from input: Substring, for regex: Regex<(Substring, count: Substring)>) -> Int? {
        input.matches(of: regex).compactMap { Int($0.output.count) }.max()
    }

    static func validate(_ max: Int?, for color: Color) -> Int {
        if let max {
            return max
        } else {
            assertionFailure("Max for \(color) not found")
            return 1
        }
    }
}
