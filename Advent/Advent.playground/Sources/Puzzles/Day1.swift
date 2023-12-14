import Foundation

public enum Day1: Advent {
	public static func firstStar(for input: String) {
		sumOfCalibrationValue(from: input, calculation: calibrationValue)
	}

	public static func secondStar(for input: String) {
		sumOfCalibrationValue(from: input, calculation: letterCalibrationValue)
	}
}

// MARK: - Private

private extension Day1 {

	enum Number: String, CaseIterable {
		case one
		case two
		case three
		case four
		case five
		case six
		case seven
		case eight
		case nine

		var intValue: Int {
			switch self {
			case .one: return 1
			case .two: return 2
			case .three: return 3
			case .four: return 4
			case .five: return 5
			case .six: return 6
			case .seven: return 7
			case .eight: return 8
			case .nine: return 9
			}
		}
	}

	static func sumOfCalibrationValue(from input: String, calculation: (String) -> Int) {
		let strings = input.components(separatedBy: .newlines)
		let sum = strings.reduce(0) { $0 + calculation($1) }
		print("SUM: \(sum)")
	}

	// MARK: - First star

	static func calibrationValue(from input: String) -> Int {
		let numbers: Array<Int> = input.compactMap{ $0.isNumber ? $0.wholeNumberValue : nil }
		return (numbers.first ?? 0) * 10 + (numbers.last ?? 0)
	}

	// MARK: - Second star

	static func letterCalibrationValue(from input: String) -> Int {
		guard !input.isEmpty else { return 0 }
		let start = input.startIndex
		let end = input.index(before: input.endIndex)

		let firstNumber = number(from: input,
								 initialIndex: start,
								 indexShift: { $0.index(after:) },
								 condition: { $0 <= end },
								 range: { start...$0 }) ?? 0

		let secondNumber = number(from: input,
								 initialIndex: end,
								 indexShift: { $0.index(before:) },
								 condition: { $0 >= start },
								 range: { $0...end }) ?? 0

		return firstNumber * 10 + secondNumber
	}

	static func number(from input: String,
					   initialIndex: String.Index,
					   indexShift: (String) -> (String.Index) -> String.Index,
					   condition: (String.Index) -> Bool,
					   range: (String.Index) -> ClosedRange<String.Index>) -> Int? {
		var index = initialIndex
		while condition(index) {
			let startChar = input[index]
			if startChar.isNumber {
				return startChar.wholeNumberValue
			} else if let foundNumber = number(from: input[range(index)]) {
				return foundNumber
			}
			index = indexShift(input)(index)
		}
		return nil
	}

	static var numbers = Number.allCases.map({ $0.rawValue })
	static func number(from input: Substring) -> Int? {
		guard let match = numbers.first(where: { input.contains($0)}) else { return nil }
		return Number(rawValue: match)?.intValue
	}
}
