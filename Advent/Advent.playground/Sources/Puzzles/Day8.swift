import Foundation

public enum Day8: Advent {

	public static func firstStar(for input: String) {
		let network = network(from: input) { _ in }
		let instructions = instructions(from: input)

		let start = "AAA"
		let end = "ZZZ"

		let steps = numberOfStepsToEnd(from: start,
									   in: network,
									   moveTo: { $0 != end },
									   chooseDirection: { direction(for: $0, from: instructions)})

		print("STEPS: \(steps)")
	}

	public static func secondStar(for input: String) {
		var startNodes: Set<String> = []
		var endNodes: Set<String> = []

		let network = network(from: input) { node in
			if node.last == "A" {
				startNodes.insert(node)
			} else if node.last == "Z" {
				endNodes.insert(node)
			}
		}

		let instructions = instructions(from: input)

		let moveTo: (String) -> Bool = { node in
			if node.last != "Z" {
				return true
			} else {
				endNodes.remove(node)
				return false
			}
		}

		var steps = startNodes.map { numberOfStepsToEnd(from: $0,
														in: network,
														moveTo: moveTo,
														chooseDirection: { direction(for: $0, from: instructions)}) }

		guard endNodes.isEmpty else {
			assertionFailure("Not all nodes reached")
			return
		}
		
		let lcm = lcm(for: &steps)
		print("STEPS: \(lcm)")
	}

}

// MARK: - Private

private extension Day8 {

	enum Instruction: Character, Hashable {
		case left = "L"
		case right = "R"
	}

	// MARK: - Common

	static func network(from input: String, validateNote: (String) -> Void) -> [String: [Instruction: String]] {
		let nodeRegex = /(?<A>[A-Z]{3})\s+\=\s+\((?<B>[A-Z]{3})\,\s+(?<C>[A-Z]{3})\)/
		var nodes: [String: [Instruction: String]] = [:]
		input.matches(of: nodeRegex).forEach { match in
			let A = String(match.output.A)
			let B = String(match.output.B)
			let C = String(match.output.C)
			nodes[A] = [.left: B, .right: C]
			validateNote(A)
		}
		return nodes
	}

	static func instructions(from input: String) -> [Instruction] {
		guard let instructions = input.firstMatch(of: /(?<instructions>(L|R)+)/)?.output.instructions else {
			assertionFailure("Instructions not found")
			return []
		}
		return instructions.compactMap { Instruction(rawValue: $0) }
	}

	static func direction(for step: Int, from instructions: [Instruction]) -> Instruction? {
		let step = step % instructions.count
		return instructions[step]
	}

	static func numberOfStepsToEnd(from start: String,
								   in network: [String: [Instruction: String]],
								   moveTo: (String) -> Bool,
								   chooseDirection: (Int) -> Instruction?) -> Int {
		var node = start
		var step = 0

		while moveTo(node) {
			guard let direction = chooseDirection(step),
				  let nextNode = network[node]?[direction] else {
				assertionFailure("Navigation is impossible")
				return 0
			}
			node = nextNode
			step += 1
		}

		return step
	}

	static func gcd(a: Int, b: Int) -> Int {
		b == 0 ? a : gcd(a: b, b: a % b)
	}

	static func lcm(a: Int, b: Int) -> Int {
		a * b / gcd(a: a, b: b)
	}

	static func lcm(for numbers: inout [Int]) -> Int {
		if numbers.count < 2 {
			return numbers.first ?? 0
		}
		if numbers.count == 2 {
			return lcm(a: numbers[0], b: numbers[1])
		}
		let number = numbers.removeLast()
		return lcm(a: number, b: lcm(for: &numbers))
	}
}
