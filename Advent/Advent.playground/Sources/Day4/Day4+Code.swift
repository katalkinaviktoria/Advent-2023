import Foundation

public enum Day4: Advent {
	public static func firstStar(for input: String) {
		sum(for: input, operation: score)
	}

	public static func secondStar(for input: String) {
	}
}

// MARK: - Internal

extension Day4 {
	static func sum(for input: String, operation: (String) -> Int) {
		let strings = input.components(separatedBy: .newlines)
		let sum = strings.reduce(0) { $0 + operation($1) }
		print("SUM: \(sum)")
	}
}

// MARK: - Private

private extension Day4 {

	// MARK: - Common
	//let regex = /Card\s+(?<card>\d+):/
	static func score(from input: String) -> Int {
//		let game = input.components(separatedBy: ":").first
		let input = input.components(separatedBy: ":").last?.components(separatedBy: "|")
//		let winningNumbers = Set(input?.first?.split(separator: /\s+/) ?? [])
//		let myNumbers = input?.last?.split(separator: /\s+/) ?? []
//		let score = myNumbers.reduce(0) { partialResult, number in
//			guard winningNumbers.contains(number) else { return partialResult }
//			return partialResult > 0 ? partialResult * 2 : 1
//		}
//		return score
		var winningNumbers: Set<String> = []
		var myWinningNumbers: Set<String> = []
		var myNumbers: Set<String> = []
		var tmpNumber: String = ""
		var score = 0

		for char in input?.first ?? "" {
			guard char.isNumber else {
				if !tmpNumber.isEmpty {
					winningNumbers.insert(tmpNumber)
				}
				tmpNumber = ""
				continue
			}
			tmpNumber += "\(char)"
		}

		for char in input?.last ?? "" {
			guard char.isNumber else {
				if !tmpNumber.isEmpty, winningNumbers.contains(tmpNumber) {
					score = score > 0 ? score * 2 : 1
					myWinningNumbers.insert(tmpNumber)
				}
				myNumbers.insert(tmpNumber)
				tmpNumber = ""
				continue
			}
			tmpNumber += "\(char)"
		}
		if !tmpNumber.isEmpty, winningNumbers.contains(tmpNumber) {
			score = score > 0 ? score * 2 : 1
			myWinningNumbers.insert(tmpNumber)
		}
		return score
	}
}
