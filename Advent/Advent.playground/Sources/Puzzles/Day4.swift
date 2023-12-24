import Foundation

public enum Day4: Advent {
    public static func firstStar(for input: String) {
        sumOfPoints(for: input)
    }

    public static func secondStar(for input: String) {
        sumOfCards(for: input)
    }
}

// MARK: - Private

private extension Day4 {

    //MARK: - First star

    static func sumOfPoints(for input: String) {
        let regex = /Card\s+(?<card>\d+)\:(?<winningNumbers>(\s+\d+)+)\s+\|(?<numbers>(\s+\d+)+)/
        let input = input.matches(of: regex)
        let sum: Decimal = input.reduce(0) { partialResult, match in
            let winningNumbers: Set<String> = Set(match.output.winningNumbers.components(separatedBy: .whitespaces)
                .compactMap { $0.isEmpty ? nil : $0 })
            let numbers: Set<String> = Set(match.output.numbers.components(separatedBy: .whitespaces)
                .compactMap { $0.isEmpty ? nil : $0 })
            let countOfWinningNumbers = winningNumbers.intersection(numbers).count
            let score = countOfWinningNumbers > 0 ? pow(2, countOfWinningNumbers - 1) : 0
            return partialResult + score
        }
        print("SUM: \(sum)")
    }

    //MARK: - First star - faster

    static func sumOfPoints(for input: String, operation: (String) -> Int) {
        let strings = input.components(separatedBy: .newlines)
        let sum = strings.reduce(0) { $0 + operation($1) }
        print("SUM: \(sum)")
    }

    static func process(_ input: String, operation: (String) -> Void) {
        var tmpNumber: String = ""
        for char in input {
            guard char.isNumber else {
                operation(tmpNumber)
                tmpNumber = ""
                continue
            }
            tmpNumber += "\(char)"
        }
        operation(tmpNumber)
    }

    static func fasterScore(from input: String) -> Int {
        let input = input.components(separatedBy: ":").last?.components(separatedBy: "|")
        guard let winningNumbersInput = input?.first, let otherNumbersInput = input?.last else {
            assertionFailure("Input is incorrect")
            return 0
        }

        var winningNumbers: Set<String> = []
        var score = 0

        process(winningNumbersInput) { number in
            if !number.isEmpty {
                winningNumbers.insert(number)
            }
        }

        process(otherNumbersInput) { number in
            if !number.isEmpty, winningNumbers.contains(number) {
                score = score > 0 ? score * 2 : 1
            }
        }

        return score
    }

    // MARK: - Second star

    static func sumOfCards(for input: String) {
        //
    }
}
