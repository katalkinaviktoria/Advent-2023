import Foundation

public enum Day1: Advent {
	public static func firstStar(for input: String) {
	}

	public static func secondStar(for input: String) {
		sum(for: input, operation: letterCalibrationValue)
	}
}

// MARK: - Internal

extension Day1 {
	static func sum(for input: String, operation: (String) -> Int) {
		let strings = input.components(separatedBy: .newlines)
		let sum = strings.reduce(0) { $0 + operation($1) }
		print("SUM: \(sum)")
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

	// MARK: - Second star

	static func letterCalibrationValue(from input: String) -> Int {
		guard !input.isEmpty else { return 0 }
		let start = input.startIndex
		let end = input.index(before: input.endIndex)
		print("first")
		let firstNumber = number(from: input,
								 initialIndex: start,
								 indexShift: { $0.index(after:) },
								 condition: { $0 <= end },
								 range: { start...$0 }) ?? 0
		print("second")
		let secondNumber = number(from: input,
								 initialIndex: end,
								 indexShift: { $0.index(before:) },
								 condition: { $0 >= start },
								 range: { $0...end }) ?? 0

		print("\(firstNumber)  \(secondNumber)")
		return firstNumber * 10 + secondNumber
	}

	static func number(from input: String,
					   initialIndex: String.Index,
					   indexShift: (String) -> (String.Index) -> String.Index,
					   condition: (String.Index) -> Bool,
					   range: (String.Index) -> ClosedRange<String.Index>) -> Int? {
		var index = initialIndex
		print("0")
		while condition(index) {
			print("1")
			let startChar = input[index]
			print("10")
			if startChar.isNumber {
				print("2")
				return startChar.wholeNumberValue
			} else if let foundNumber = number(from: input[range(index)]) {
				print("3")
				return foundNumber
			}
			print("4")
			index = indexShift(input)(index)
			print("5")
		}
		return nil
	}

	static var numbers = Number.allCases.map({ $0.rawValue })
	static func number(from input: Substring) -> Int? {
		print("6")
		guard let match = numbers.first(where: { input.contains($0)}) else { return nil }
		print("7")
		return Number(rawValue: match)?.intValue
	}
}

let adventDay: Advent.Type = Day1.self

do {
	let input = try adventDay.input(for: "day1")

//	measureAverageTime({adventDay.firstStar(for: input)})
//	reportMemory()

	measureTime({adventDay.secondStar(for: input)})
	reportMemory()
} catch {
	print(error)
}
