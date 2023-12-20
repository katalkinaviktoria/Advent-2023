import Foundation


let aa = 1..<5
aa.upperBound
aa.lowerBound
let nn = 4..<12
nn.lowerBound
nn.upperBound

aa.overlaps(nn)

aa.count

let adventDay: Advent.Type = Day5.self

do {
	let resource = String(describing: adventDay).lowercased()
	let input = try adventDay.input(for: resource, resourceExtension: "txt")

	measureTime({adventDay.firstStar(for: input)})
	reportMemory()

//	measureTime({adventDay.secondStar(for: input)})
//	reportMemory()
} catch {
	print(error)
}

let resource = String(describing: adventDay).lowercased()
let input = try adventDay.input(for: resource, resourceExtension: "txt")

let seedsMatch = input.firstMatch(of: /seeds:.+\n/)
seedsMatch?.output
let seedsMatch1 = seedsMatch?.output.matches(of: /\s(?<start>\d+)\s(?<length>\d+)/)
