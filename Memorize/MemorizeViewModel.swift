import SwiftUI

class MemorizeViewModel: ObservableObject {
    
    private static let themes: [Theme] = [
        Theme(name: "Animals", emoji: ["🐱", "🐥", "🐙", "🐼", "🦩", "🐑", "🐭", "🐳", "🐍", "🦋"], color: "orange"),
        Theme(name: "Foods", emoji: ["🥐", "🧁", "☕️", "🍕", "🍦", "🍜", "🍔", "🍗", "🍧", "🍳", "🥗"], color: "mint"),
        Theme(name: "Transport", emoji: ["🚁", "🚘", "✈️", "⛵️", "🚂", "🚜", "🛵", "🚚", "🚲", "🛥️"], color: "blue"),
        Theme(name: "Smiles", emoji: ["😍", "😜", "😎", "😴", "🤣", "🤠", "😇", "🥳", "🥸", "🤗"], color: "cyan"),
        Theme(name: "Sport", emoji: ["🥎", "🛼", "🏓", "⛸️", "⚽️", "🏒", "🥊", "🏏"], color: "red"),
        Theme(name: "Nature", emoji: ["🌻", "🌵", "🪻", "🌳", "🌴", "🪷", "🍄", "🌷", "🌾", "🌲"], color: "green")
        ]
    
    static func createMemoryGame(theme: Theme) -> MemorizeModel<String> {
        let numberOfPairsOfCards = Int.random(in: 2...theme.emoji.count)
        return MemorizeModel(numberOfPairsOfCards: numberOfPairsOfCards) { pairIndex in
            return theme.emoji[pairIndex]
        }
    }
    
    @Published private var model: MemorizeModel<String>
    @Published var currentTheme: Theme
    @Published var gameScore: Int?
    
    var cards: Array<MemorizeModel<String>.Card> {
        model.cards
    }
    
    init() {
        let randomTheme = Self.themes.randomElement()!
        self.currentTheme = randomTheme
        self.model = Self.createMemoryGame(theme: randomTheme)
        self.gameScore = self.model.gameScore
        model.onGameScoreChange = { [weak self] score in
            self?.gameScore = score
        }
    }
    
    func selectRandomTheme() {
        currentTheme = Self.themes.randomElement()!
        model = Self.createMemoryGame(theme: currentTheme)
        model.onGameScoreChange = { [weak self] score in
            self?.gameScore = score
        }
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: MemorizeModel<String>.Card) {
        model.choose(card)
    }
    
    func updateGameScore() {
            gameScore = model.gameScore
        }
    
    func checkColor() -> Color {
        let color = currentTheme.color
        switch color {
        case "orange":
            return .orange
        case "red":
            return .red
        case "cyan":
            return .cyan
        case "green":
            return .green
        case "blue":
            return .blue
        case "mint":
            return .mint
        default:
            return .gray
        }
    }
}
