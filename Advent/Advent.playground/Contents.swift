import Foundation

let adventDay: Advent.Type = Day5.self

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
