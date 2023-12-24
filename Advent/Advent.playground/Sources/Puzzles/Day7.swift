import Foundation

public enum Day7: Advent {
    public static func firstStar(for input: String) {
        totalWinnings(for: input, cardValueMap: cardValueMap, handType: defineHandType)
    }

    public static func secondStar(for input: String) {
        var cardValueMap = cardValueMap
        cardValueMap["J"] = 1
        totalWinnings(for: input, cardValueMap: cardValueMap, handType: defineHandTypeWithJoker)
    }
}

// MARK: - Private

private extension Day7 {

    static var cardValueMap: [Character: Int] = [
        "A": 14,
        "K": 13,
        "Q": 12,
        "J": 11,
        "T": 10,
        "9": 9,
        "8": 8,
        "7": 7,
        "6": 6,
        "5": 5,
        "4": 4,
        "3": 3,
        "2": 2
    ]

    struct Hand: Hashable {
        var cards: String
        var bid: Int
    }

    enum HandType: Comparable {
        case highCard
        case onePair
        case twoPair
        case threeOfAKind
        case fullHouse
        case fourOfAKind
        case fiveOfAKind
    }

    static func totalWinnings(for input: String, cardValueMap: [Character: Int], handType: (String) -> HandType?) {
        let matches = input.matches(of: /(?<cards>\w{5})\s(?<bid>\d+)/)
        var hands: Set<Hand> = []
        matches.forEach { match in
            if let bid = Int(match.output.bid) {
                let hand = Hand(cards: String(match.output.cards), bid: bid)
                hands.insert(hand)
            } else {
                assertionFailure("Bid not found")
            }
        }

        var sortedHands = hands.sorted { lhs, rhs in
            guard let lhsType = handType(lhs.cards), let rhsType = handType(rhs.cards) else {
                assertionFailure("HandType not found")
                return false
            }
            return lhsType == rhsType ? compareHands(lhs: lhs.cards, rhs: rhs.cards, cardValueMap: cardValueMap) : lhsType < rhsType
        }

        let sum = winnings(for: &sortedHands, rank: 1, sum: 0)
        print("SUM: \(sum)")
    }

    static func compareHands(lhs: String, rhs: String, cardValueMap: [Character: Int]) -> Bool {
        var lhsIndex = lhs.startIndex
        var rhsIndex = rhs.startIndex

        while lhs[lhsIndex] == rhs[rhsIndex] {
            lhsIndex = lhs.index(after: lhsIndex)
            rhsIndex = lhs.index(after: rhsIndex)
        }

        guard let lhsCardValue = cardValueMap[lhs[lhsIndex]],
                let rhsCardValue = cardValueMap[rhs[rhsIndex]] else {
            assertionFailure("Card values not found")
            return false
        }

        return lhsCardValue < rhsCardValue
    }

    static func winnings(for hands: inout [Hand], rank: Int, sum: Int) -> Int {
        guard !hands.isEmpty else { return sum }
        let hand = hands.removeFirst()
        return winnings(for: &hands, rank: rank + 1, sum: hand.bid * rank + sum)
    }

    // MARK: - First star

    static func defineHandType(for cards: String) -> HandType? {
        guard cards.count == 5 else { return nil }

        var map: [Character: Int] = [:]
        cards.forEach { card in
            map[card] = (map[card] ?? 0) + 1
        }

        let numberOfCard = map.map { $0.value }.sorted(by: <)
        switch numberOfCard {
        case [5]: return .fiveOfAKind
        case [1, 4]: return .fourOfAKind
        case [2, 3]: return .fullHouse
        case [1, 1, 3]: return .threeOfAKind
        case [1, 2, 2]: return .twoPair
        case [1, 1, 1, 2]: return .onePair
        case [1, 1, 1, 1, 1]: return .highCard
        default: return nil
        }
    }

    // MARK: - Second star

    static func defineHandTypeWithJoker(for cards: String) -> HandType? {
        guard let handType = defineHandType(for: cards) else { return nil }

        let jokerCount = cards.filter { $0 == "J" }.count
        guard jokerCount > 0 else { return handType }

        switch handType {
        case .fiveOfAKind, .fourOfAKind, .fullHouse: return .fiveOfAKind
        case .threeOfAKind: return .fourOfAKind
        case .twoPair: return jokerCount > 1 ? .fourOfAKind : .fullHouse
        case .onePair: return .threeOfAKind
        case .highCard: return .onePair
        }
    }
}
