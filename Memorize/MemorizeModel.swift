import Foundation

struct Theme {
    var name: String
    var emoji: [String]
    var color: String
}

struct MemorizeModel<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var gameScore: Int
    
    var onGameScoreChange: ((Int) -> Void)?
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter { index in cards[index].isFaceUp }.only
        }
        set {
            cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) }
        }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        gameScore = 0
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex + 1)a"))
            cards.append(Card(content: content, id: "\(pairIndex + 1)b"))
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
        print(cards)
        gameScore = 0
        onGameScoreChange?(gameScore)
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialIndex].isMatched = true
                        gameScore += 2
                    } else {
                        if cards[chosenIndex].isSeen {
                            gameScore -= 1
                        }
                        if cards[potentialIndex].isSeen {
                            gameScore -= 1
                        }
                        cards[chosenIndex].isSeen = true
                        cards[potentialIndex].isSeen = true
                    }
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
                onGameScoreChange?(gameScore)
            }
        }
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var isFaceUp = false
        var isMatched = false
        var isSeen = false
        let content: CardContent
        var id: String
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "") \(isSeen ? "seen" : "")"
        }
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
