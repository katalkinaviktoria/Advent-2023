import Foundation


public enum Day2: Advent {
	public static func firstStar(for input: String) {
		sum(for: input, operation: possibleGameID)
	}

	public static func secondStar(for input: String) {
		sum(for: input, operation: powerOfGame)
	}
}

// MARK: - Internal

extension Day2 {
	static func sum(for input: String, operation: (String) -> Int) {
		let strings = input.components(separatedBy: .newlines)
		let sum = strings.reduce(0) { $0 + (operation($1)) }
		print("SUM: \(sum)")
	}
}

// MARK: - Private

private extension Day2 {
	static var gameRegex = /Game (?<game>\d+):/
	static var redRegex = /(?<count>\d+) red/
	static var blueRegex = /(?<count>\d+) blue/
	static var greenRegex = /(?<count>\d+) green/

	// MARK: - First star

	static func possibleGameID(from input: String) -> Int {
		let maxRedCount = 12
		let maxGreenCount = 13
		let maxBlueCount = 14

		let game = try? gameRegex.firstMatch(in: input)?.output.game
		guard let game = game, let gameNumber = Int(game) else { return 0 }

		guard validateInput(input, with: maxRedCount, regex: redRegex) else { return 0 }
		guard validateInput(input, with: maxBlueCount, regex: blueRegex) else { return 0 }
		guard validateInput(input, with: maxGreenCount, regex: greenRegex) else { return 0 }

		return gameNumber
	}

	// MARK: - Second star

	static func powerOfGame(from input: String) -> Int {
		let redMax = max(from: input, for: redRegex) ?? 1
		let blueMax = max(from: input, for: blueRegex) ?? 1
		let greenMax = max(from: input, for: greenRegex) ?? 1

		return redMax * greenMax * blueMax
	}

	// MARK: - Common

	static func validateInput(_ input: String, with max: Int, regex: Regex<(Substring, count: Substring)>) -> Bool {
		!input.matches(of: regex).contains(where: { result in
			let current = Int(result.output.count) ?? 0
			return current > max
		})
	}

	static func max(from input: String, for regex: Regex<(Substring, count: Substring)>) -> Int? {
		input.matches(of: regex).compactMap { Int($0.output.count) }.max()
	}
}
