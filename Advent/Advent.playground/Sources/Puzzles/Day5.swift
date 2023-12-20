import Foundation

public enum Day5: Advent {
	public static func firstStar(for input: String) {
		minLocation(from: input)
	}

	public static func secondStar(for input: String) {
		//
	}
}

// MARK: - Private

private extension Day5 {

	// MARK: - Common

	static var regexes: [Regex<(Substring, map: Substring, Substring)>] = {
		let soilFromSeedRegex = /seed-to-soil map:\n(?<map>(.+\n)+)/
		let fertilizerFromSoilRegex = /soil-to-fertilizer map:\n(?<map>(.+\n)+)/
		let waterFromFertilizerRegex = /fertilizer-to-water map:\n(?<map>(.+\n)+)/
		let lightFromWaterRegex = /water-to-light map:\n(?<map>(.+\n)+)/
		let temperatureFromLightRegex = /light-to-temperature map:\n(?<map>(.+\n)+)/
		let humidityFromTemperatureRegex = /temperature-to-humidity map:\n(?<map>(.+\n)+)/
		let locationFromHumidityRegex = /humidity-to-location map:\n(?<map>(.+\n)+)/

		return [soilFromSeedRegex,fertilizerFromSoilRegex, waterFromFertilizerRegex,
				lightFromWaterRegex, temperatureFromLightRegex, humidityFromTemperatureRegex,
				locationFromHumidityRegex]
	}()

	//MARK: - First star

	static func minLocation(from input: String) {
		guard let seedsMatch = input.firstMatch(of: /seeds:(?<seeds>(\s+\d+)+)/) else { return }
		let seeds = seedsMatch.output.seeds.components(separatedBy: .whitespaces).compactMap { Int($0) }

		var locations: [Int] = []

		for seed in seeds {
			var regexes = regexes
			let location = matching(for: seed, input: input, regexes: &regexes)
			locations.append(location)
		}

		guard let min = locations.min() else {
			assertionFailure("Location min not found")
			return
		}

		print("MIN: \(min)")
	}

	static func matching(for start: Int, input: String, regexes: inout [Regex<(Substring, map: Substring, Substring)>]) -> Int {
		if regexes.count == 1 {
			return matching(for: start, input: input, regex: regexes.first!)
		}
		let regex = regexes.removeLast()
		return matching(for: matching(for: start, input: input, regexes: &regexes), input: input, regex: regex)
	}

	static func matching(for value: Int, input: String, regex: Regex<(Substring, map: Substring, Substring)>) -> Int {
		guard let match = input.firstMatch(of: regex) else {
			assertionFailure("Match not found")
			return 0
		}

		let mapRegex = /(?<destinationRangeStart>\d+) (?<sourceRangeStart>\d+) (?<rangeLength>\d+)/
		typealias FromToMap = (from: Int, to: Int, length: Int)

		let map = match.output.map.matches(of: mapRegex).compactMap { match -> FromToMap? in
			guard let from = Int(match.output.sourceRangeStart),
				  let to = Int(match.output.destinationRangeStart),
				  let length = Int(match.output.rangeLength) else { return nil }
			return FromToMap(from: from, to: to, length: length)
		}

		var to = value
		let range = map.first { ($0.from..<$0.from + $0.length).contains(value) }
		if let range {
			to = range.to + value - range.from
		}

		return to
	}

	// MARK: - Second star
}
