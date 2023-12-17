import Foundation

let adventDay: Advent.Type = Day6.self

do {
	let input = try adventDay.input(for: "day6")

	measureTime({adventDay.firstStar(for: input)})
	reportMemory()

	measureAverageTime({adventDay.secondStar(for: input)})
	reportMemory()
} catch {
	print(error)
}
