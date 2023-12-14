import Foundation

public protocol Advent {
	static func firstStar(for input: String)
	static func secondStar(for input: String)

	static func input(for day: String) throws -> String
}

public extension Advent {
	 static func input(for day: String) throws -> String {
		guard let url = Bundle.main.url(forResource: day, withExtension: "txt") else {
			throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError)
		}
		let fileContents = try String(contentsOf: url, encoding: .utf8)
		return fileContents
	}
}
