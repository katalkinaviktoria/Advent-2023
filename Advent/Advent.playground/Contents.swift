import Foundation

let adventDay: Advent.Type = Day2.self

do {
	let resource = String(describing: adventDay).lowercased()
	let input = try adventDay.input(for: resource, resourceExtension: "txt")

	measureTime({adventDay.firstStar(for: input)})
	reportMemory()

	measureTime({adventDay.secondStar(for: input)})
	reportMemory()
} catch {
	print(error)
}

let input1 = """
Card   1: 26 36 90 | 26 36 90 11
Card   2: 45 10 54 | 45 10 55 12
Card   3: 37 31 21 | 37 20 10 11
Card   4: 16 82 44 |  1 12 13 14
"""

func foo(copy: Int, for string: Substring) -> Int {
	let regex = /Card\s+(?<card>\d+)\:(?<winningNumbers>(\s+\d+)+)\s+\|(?<numbers>(\s+\d+)+)/
	guard let match = string.firstMatch(of: regex) else {
		return 0
	}

	let winningNumbers: Set<String> = Set(match.output.winningNumbers.components(separatedBy: .whitespaces)
		.compactMap { $0.isEmpty ? nil : $0 })
	let numbers: Set<String> = Set(match.output.numbers.components(separatedBy: .whitespaces)
		.compactMap { $0.isEmpty ? nil : $0 })

	let countOfWinningNumbers = winningNumbers.intersection(numbers).count
	print(countOfWinningNumbers)
	return foo(copy: countOfWinningNumbers + copy, for: string[match.range.upperBound..<string.endIndex])
}

foo(copy: 1, for: input1[input1.startIndex..<input1.endIndex])
//
//1 3 7 13
//
//(1 + 1) + 1*((1+1)+1) + 2* (1+1)
