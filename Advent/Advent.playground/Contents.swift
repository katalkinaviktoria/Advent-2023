import Foundation

let adventDay: Advent.Type = Day8.self

do {
	let input = try adventDay.input(for: "day8")

	measureAverageTime({adventDay.firstStar(for: input)})
	reportMemory()

	measureAverageTime({adventDay.secondStar(for: input)})
	reportMemory()
} catch {
	print(error)
}
