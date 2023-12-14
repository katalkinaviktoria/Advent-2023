import Foundation
import Algorithms
import simd

public enum Day3: Advent {
	public static func firstStar(for input: String) {
		let (symbols, numbers) = prepareData(from: input, compareOperation: { $0 != "." })

		var adjacentNumbers: Set<Number> = []
		for symbol in symbols {
			insertAdjacentNumbers(to: &adjacentNumbers, for: symbol, from: numbers)
		}
		let sum = adjacentNumbers.reduce(0) { $0 + $1.value }

		print("SUM: \(sum)")
	}

	public static func secondStar(for input: String) {
		let (symbols, numbers) = prepareData(from: input, compareOperation: { $0 == "*" || $0.isNumber })

		var sum = 0
		for symbol in symbols {
			var adjacentNumbers: Set<Number> = []
			insertAdjacentNumbers(to: &adjacentNumbers, for: symbol, from: numbers)
			if adjacentNumbers.count > 1 {
				sum += adjacentNumbers.reduce(1) { $0 * $1.value }
			}
		}

		print("SUM: \(sum)")
	}
}

// MARK: - Private

private extension Day3 {

	class Number: Hashable {
		var value: Int
		var coordinates: [SIMD2<Int>]

		// MARK: - Init

		init(value: Int, coordinates: [SIMD2<Int>]) {
			self.value = value
			self.coordinates = coordinates
		}

		// MARK: - Hashable

		static func == (lhs: Number, rhs: Number) -> Bool {
			return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
		}

		func hash(into hasher: inout Hasher) {
			hasher.combine(ObjectIdentifier(self))
		}
	}

	// MARK: - Common

	static func prepareData(from input: String, 
							compareOperation: (Character) -> Bool
	) -> (symbols: Set<SIMD2<Int>>, numbers: [SIMD2<Int>: Number]) {
		var symbols: Set<SIMD2<Int>> = []
		var numbers: [SIMD2<Int>: Number] = [:]

		var x = 0
		var y = 1

		var tmpNumber: Number? = nil

		for char in input {
			if !char.isNumber, let number = tmpNumber {
				let coordinate = SIMD2<Int>(x: x, y: y)
				number.coordinates.append(coordinate)
				numbers[coordinate] = number
				tmpNumber = nil
			}

			guard !char.isNewline else {
				y += 1
				x = 0
				continue
			}

			x += 1

			guard compareOperation(char) else { continue }

			let coordinate = SIMD2<Int>(x: x, y: y)

			guard char.isNumber else {
				symbols.insert(coordinate)
				continue
			}

			let value = char.wholeNumberValue ?? 0
			if let number = tmpNumber {
				number.value = number.value * 10 + value
				number.coordinates.append(coordinate)
			} else {
				tmpNumber = Number(value: value, coordinates: [coordinate])
			}
			numbers[coordinate] = tmpNumber
		}

		return (symbols: symbols, numbers: numbers)
	}

	static func insertAdjacentNumbers(to adjacentNumbers: inout Set<Number>, for symbol: SIMD2<Int>, from numbers: [SIMD2<Int>: Number]) {
		let vectorCombinations = [-1, -1, 0, 1, 1].uniquePermutations(ofCount: 2)
		let surroundingCoordinates = vectorCombinations.map { vector in
			SIMD2<Int>(x: vector[0], y: vector[1]) &+ symbol
		}
		surroundingCoordinates.forEach { coordinate in
			if let adjacentNumber = numbers[coordinate] {
				adjacentNumbers.insert(adjacentNumber)
			}
		}
	}
}
