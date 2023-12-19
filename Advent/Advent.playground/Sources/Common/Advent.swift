import Foundation

public protocol Advent {
	static func firstStar(for input: String)
	static func secondStar(for input: String)

	static func input(for resource: String, resourceExtension: String) throws -> String
}

extension Advent {
	public static func input(for resource: String, resourceExtension: String) throws -> String {
		guard let url = Bundle.main.url(forResource: resource, withExtension: resourceExtension) else {
			throw NSError(domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError)
		}
		let fileContents = try String(contentsOf: url, encoding: .utf8)
		return fileContents
	}
}
