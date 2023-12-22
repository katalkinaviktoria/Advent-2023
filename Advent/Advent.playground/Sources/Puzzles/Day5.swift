import Foundation

public enum Day5: Advent {
	public static func firstStar(for input: String) {
		let seeds: (Substring) -> [Int] = { seeds in seeds.components(separatedBy: .whitespaces).compactMap { Int($0) }}
		minLocation(from: input,
					regex: /seeds:(?<seeds>(\s+\d+)+)/,
					seeds: seeds,
					calculate: shiftValue,
					min: { locations in locations.min() })
	}

	public static func secondStar(for input: String) {
		let seeds: (Substring) -> [Range<Int>] = { seeds in
			seeds.matches(of: /\s(?<start>\d+)\s(?<length>\d+)/).compactMap { match -> Range<Int>? in
				guard let start = Int(match.output.start), let length = Int(match.output.length) else {
					assertionFailure("Seed range not found")
					return nil
				}
				return start..<start + length
			}
		}
		minLocation(from: input,
					regex: /seeds:(?<seeds>(.*))\n/,
					seeds: seeds,
					calculate: shiftRanges,
					min: { locations in locations.min(by: { $0.lowerBound < $1.lowerBound })?.lowerBound })
	}
}

// MARK: - Private

private extension Day5 {

	// MARK: - Common

	typealias ShiftRange = (range: Range<Int>, shift: Int)

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

	static func minLocation<T>(from input: String,
							   regex: Regex<(Substring, seeds: Substring, Substring)>,
							   seeds: (Substring) -> [T],
							   calculate: (T, [ShiftRange]) -> [T], 
							   min: ([T]) -> Int?) {
		guard let seedsMatch = input.firstMatch(of: regex) else {
			assertionFailure("Seeds not found")
			return
		}

		let seeds = seeds(seedsMatch.output.seeds)

		var regexes = regexes
		let locations = matching(for: seeds, input: input, regexes: &regexes, calculate: calculate)

		guard let min = min(locations) else {
			assertionFailure("Location min not found")
			return
		}

		print("MIN: \(min)")
	}

	static func matching<T>(for values: [T],
							input: String,
							regexes: inout [Regex<(Substring, map: Substring, Substring)>],
							calculate: (T, [ShiftRange]) -> [T]) -> [T] {
		if regexes.count == 1, let regex = regexes.first {
			return matching(for: values, input: input, regex: regex, calculate: calculate)
		}
		let regex = regexes.removeLast()
		return matching(for: matching(for: values, input: input, regexes: &regexes, calculate: calculate),
						input: input,
						regex: regex,
						calculate: calculate)
	}

	static func matching<T>(for values: [T],
							input: String,
							regex: Regex<(Substring, map: Substring, Substring)>,
							calculate: (T, [ShiftRange]) -> [T]) -> [T] {
		guard let match = input.firstMatch(of: regex) else {
			assertionFailure("Match not found")
			return []
		}

		let mapRegex = /(?<destinationRangeStart>\d+) (?<sourceRangeStart>\d+) (?<rangeLength>\d+)/

		let map = match.output.map.matches(of: mapRegex).compactMap { match -> ShiftRange? in
			guard let from = Int(match.output.sourceRangeStart),
				  let to = Int(match.output.destinationRangeStart),
				  let length = Int(match.output.rangeLength) else { return nil }
			return ShiftRange(range: from..<from + length, shift: to - from)
		}

		let values = values.flatMap { calculate($0, map) }
		return values
	}

	//MARK: - First star

	static func shiftValue(for value: Int, map: [ShiftRange]) -> [Int] {
		if let range = map.first(where: { $0.range.contains(value) }) {
			return [value + range.shift]
		} else {
			return [value]
		}
	}

	// MARK: - Second star

	static func shiftRanges(for range: Range<Int>, map: [ShiftRange]) -> [Range<Int>] {
		var ranges: [Range<Int>] = []

		var currentLowerBound = range.lowerBound
		while currentLowerBound != range.upperBound {

			var upperBound: Int
			var shift: Int

			if let currentRange = map.first(where: { $0.range.contains(currentLowerBound) }) {
				upperBound = currentRange.range.upperBound > range.upperBound ? range.upperBound : currentRange.range.upperBound
				shift = currentRange.shift
			} else if let minRange = map.filter({ $0.range.lowerBound > currentLowerBound}).min(by: { $0.range.lowerBound < $1.range.lowerBound }) {
				upperBound = minRange.range.lowerBound > range.upperBound ? range.upperBound : minRange.range.lowerBound
				shift = 0
			} else {
				upperBound = range.upperBound
				shift = 0
			}

			ranges.append(currentLowerBound + shift..<upperBound + shift)
			currentLowerBound = upperBound
		}

		return ranges
	}
}
