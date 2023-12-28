import Foundation

let adventDay: Advent.Type = Day11.self

do {
    let resource = String(describing: adventDay).lowercased()
    let input = try adventDay.input(for: resource, resourceExtension: "txt")

    measureAverageTime({adventDay.firstStar(for: input)})
    reportMemory()

    measureAverageTime({adventDay.secondStar(for: input)})
    reportMemory()
} catch {
    print(error)
}

