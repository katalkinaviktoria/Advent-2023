import Foundation

public enum Day19: Advent {

	public static func firstStar(for input: String) {
		let regex = /(?<name>[a-z]{2,3})\{(?<rules>.*)\,(?<end>[a-z]{2,3}|A|R)\}/
		let ruleRegex = /(?<category>x|m|a|s)(?<compare><|>)(?<value>\d+)\:(?<next>[a-z]{2,3}|A|R)/

		var workflows: [String: Workflow] = [:]

		input.matches(of: regex).forEach { match in
			var rules: [Rule] = []
			match.output.rules.matches(of: ruleRegex).forEach { match in
				guard let category = Category(rawValue: String(match.output.category)),
					  let sign = Sign(rawValue: String(match.output.compare)),
					  let value = Int(match.output.value) else { return }
				let rule = Rule(category: category,
								compare: sign.method(value),
								next: String(match.output.next))
				rules.append(rule)
			}
			let name = String(match.output.name)
			let workflow = Workflow(name: name,
									rules: rules,
									end: String(match.output.end))

			workflows[name] = workflow
		}

		let startWorkflowName = "in"
		let detailRegex = /{x=(?<x>\d+),m=(?<m>\d+),a=(?<a>\d+),s=(?<s>\d+)\}/

		var acceptedDetailsSum: Int = 0

		input.matches(of: detailRegex).forEach { match in
			var name = startWorkflowName

			let x = Int(String(match.output.x))
			let m = Int(String(match.output.m))
			let a = Int(String(match.output.a))
			let s = Int(String(match.output.s))

			let characteristics: [Category: Int?] = [.cool: x, .musical: m, .aerodynamic: a, .shiny: s]

			while name != "A" || name != "R" {
				guard let workflow = workflows[name] else { return }

				let suitableRule = workflow.rules.first { rule in
					if let characteristic = characteristics[rule.category], let characteristic {
						let res = rule.compare(characteristic)
						return res
					}
					return false
				}

				if let suitableRule {
					name = suitableRule.next
				} else {
					name = workflow.end
				}

				if name == "A" {
					acceptedDetailsSum += characteristics.reduce(0) { $0 + ($1.value ?? 0) }
				}
			}
		}
		print("SUM: \(acceptedDetailsSum)")
	}

	public static func secondStar(for input: String) {
		//
	}

}

// MARK: - Private

private extension Day19 {

	struct Workflow {
		let name: String
		let rules: [Rule]
		let end: String
	}

	struct Rule {
		let category: Category
		let compare: (Int) -> Bool
		let next: String
	}

	enum Category: String {
		case cool = "x"
		case musical = "m"
		case aerodynamic = "a"
		case shiny = "s"
	}

	enum Sign: String {
		case more = ">"
		case less = "<"

		var method: (Int) -> (Int) -> Bool {
			switch self {
			case .more: return { b in { a in a > b } }
			case .less: return { b in { a in a < b } }
			}
		}
	}
}
