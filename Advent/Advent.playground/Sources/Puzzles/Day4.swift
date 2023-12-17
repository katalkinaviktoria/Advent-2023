import Foundation

public enum Day4: Advent {
	public static func firstStar(for input: String) {
		sumOfPoints(for: input, operation: score)
	}

	public static func secondStar(for input: String) {
		//
	}
}

// MARK: - Private

private extension Day4 {

	// MARK: - Common

	static func sumOfPoints(for input: String, operation: (String) -> Int) {
		let strings = input.components(separatedBy: .newlines)
		let sum = strings.reduce(0) { $0 + operation($1) }
		print("SUM: \(sum)")
	}

	static func process(_ input: String, operation: (String) -> Void) {
		var tmpNumber: String = ""
		for char in input {
			guard char.isNumber else {
				operation(tmpNumber)
				tmpNumber = ""
				continue
			}
			tmpNumber += "\(char)"
		}
		operation(tmpNumber)
	}

	//MARK: - First star

	static func score(from input: String) -> Int {
		let input = input.components(separatedBy: ":").last?.components(separatedBy: "|")
		var winningNumbers: Set<String> = []
		var score = 0

		process(input?.first ?? "") { number in
			if !number.isEmpty {
				winningNumbers.insert(number)
			}
		}

		process(input?.last ?? "") { number in
			if !number.isEmpty, winningNumbers.contains(number) {
				score = score > 0 ? score * 2 : 1
			}
		}

		return score
	}

	// MARK: - Second star
}
