import SwiftUI

class MemorizeViewModel: ObservableObject {
    private static let emojis = ["🐱", "🐥", "🐙", "🐼", "🦩", "🐑", "🐭", "🐳", "🐍", "🦋"]
    let emojisAnimal = ["🐱", "🐥", "🐙", "🐼", "🦩", "🐑", "🐭", "🐳", "🐍", "🦋"]
    let emojisFood = ["🥐", "🧁", "☕️", "🍕", "🍦", "🍜", "🍔", "🍗", "🍧", "🍳", "🥗"]
    let emojisTransport = ["🚁", "🚘", "✈️", "⛵️", "🚂", "🚜", "🛵", "🚚", "🚲", "🛥️"]
    
    private static func createMemoryGame() -> MemorizeModel<String> {
        return MemorizeModel(numberOfPairsOfCards: 6) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "⁉️"
            }
        }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<MemorizeModel<String>.Card> {
        return model.cards
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemorizeModel<String>.Card) {
        model.choose(card)
    }
    
    func widthThatBestFits() -> CGFloat {
        let cardCount = MemorizeViewModel.emojis.count
        
        if cardCount == 8 {
            return 90
        } else if cardCount < 16 {
            return 80
        } else {
            return 65
        }
    }
}
