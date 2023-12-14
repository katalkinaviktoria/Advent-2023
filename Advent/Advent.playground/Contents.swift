import Foundation

let adventDay: Advent.Type = Day4.self

do {
	let input = try adventDay.input(for: "day4")

	measureAverageTime({adventDay.firstStar(for: input)})
	reportMemory()

//	measureAverageTime({adventDay.secondStar(for: input)})
//	reportMemory()
} catch {
	print(error)
}
