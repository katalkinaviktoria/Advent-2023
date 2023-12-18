import Foundation

public enum Day2: Advent {
	public static func firstStar(for input: String) {
		sumOfGames(from: input, calculation: possibleGameID)
	}

	public static func secondStar(for input: String) {
		sumOfGames(from: input, calculation: powerOfGame)
	}
}

// MARK: - Private

private extension Day2 {
	static var gameRegex = /Game (?<game>\d+):/

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

	static func sumOfGames(from input: String, calculation: (String) -> Int) {
		let strings = input.components(separatedBy: .newlines)
		let sum = strings.reduce(0) { $0 + (calculation($1)) }
		print("SUM: \(sum)")
	}

	// MARK: - First star

	static func possibleGameID(from input: String) -> Int {
		guard !input.isEmpty else { return 0 }

		let game = try? gameRegex.firstMatch(in: input)?.output.game
		guard let game = game, let gameNumber = Int(game) else {
			assertionFailure("Game not found")
			return 0
		}

		guard Color.allCases.reduce(true, { $0 && validate(input, for: $1) }) else { return 0 }
		return gameNumber
	}

	static func validate(_ input: String, for color: Color) -> Bool {
		!input.matches(of: color.countRegex).contains(where: { result in
			let current = Int(result.output.count) ?? 0
			return current > color.maxCount
		})
	}

	// MARK: - Second star

	static func powerOfGame(from input: String) -> Int {
		guard !input.isEmpty else { return 0 }
		return Color.allCases.reduce(1) { $0 * validate(max(from: input, for: $1.countRegex), for: $1) }
	}

	static func max(from input: String, for regex: Regex<(Substring, count: Substring)>) -> Int? {
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
