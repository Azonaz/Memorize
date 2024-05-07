import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: MemorizeViewModel
//    @State var emojis: [String] = []
//    let emojisAnimal = ["🐱", "🐥", "🐙", "🐼", "🦩", "🐑", "🐭", "🐳", "🐍", "🦋"]
//    let emojisFood = ["🥐", "🧁", "☕️", "🍕", "🍦", "🍜", "🍔", "🍗", "🍧", "🍳", "🥗"]
//    let emojisTransport = ["🚁", "🚘", "✈️", "⛵️", "🚂", "🚜", "🛵", "🚚", "🚲", "🛥️"]
    
    @State var selectedCategory: EmojiCategory = .animal
    @State var cardColor: Color = .orange
    
    enum EmojiCategory {
        case animal, food, transport
    }
    
    var body: some View {
        Text("Memorize!")
            .font(.largeTitle)
        VStack {
            ScrollView {
                cards
            }
            Button("Shuffle") {
                viewModel.shuffle()
            }
            Spacer()
            cardAdjusters
        }
        .padding()
        .onAppear {
            updateEmojis()
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: viewModel.widthThatBestFits()), spacing: 0)], spacing: 0) {
            ForEach(0..<viewModel.cards.count, id: \.self) { index in
                CardView(viewModel.cards[index])
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding()
            }
        }
        .foregroundColor(cardColor)
    }
    
    var cardAdjusters: some View {
        HStack {
            cardsAnimal
            Spacer()
            cardsFood
            Spacer()
            cardsTransport
        }
    }
    
    func cartAdjuster (symbol: String, text: String, category: EmojiCategory) -> some View {
        Button(action: {
            selectedCategory = category
            updateEmojis()
        }, label: {
            VStack {
                Image(systemName: symbol)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding(.bottom, 5)
                Text(text)
                    .font(.body)
            }
        })
    }
    
    func updateEmojis() {
        var combinedEmojis: [String] = []
        var randomCount: Int = 4
        
        switch selectedCategory {
        case .animal:
            randomCount = Int.random(in: 4...viewModel.emojisAnimal.count)
            let selectedEmojis = Array(viewModel.emojisAnimal.shuffled().prefix(randomCount))
            combinedEmojis = selectedEmojis + selectedEmojis
            cardColor = .orange
        case .food:
            randomCount = Int.random(in: 4...viewModel.emojisFood.count)
            let selectedEmojis = Array(viewModel.emojisFood.shuffled().prefix(randomCount))
            combinedEmojis = selectedEmojis + selectedEmojis
            cardColor = .green
        case .transport:
            randomCount = Int.random(in: 4...viewModel.emojisTransport.count)
            let selectedEmojis = Array(viewModel.emojisTransport.shuffled().prefix(randomCount))
            combinedEmojis = selectedEmojis + selectedEmojis
            cardColor = .red
        }
//        emojis = combinedEmojis.shuffled()
    }
    
    var cardsAnimal: some View {
        cartAdjuster(symbol: "pawprint", text: "Animals", category: .animal)
    }
    
    var cardsFood: some View {
        cartAdjuster(symbol: "mug", text: "Food", category: .food)
    }
    
    var cardsTransport: some View {
        cartAdjuster(symbol: "car", text: "Transport", category: .transport)
    }
    
}

struct CardView: View {
    let card: MemorizeModel<String>.Card
    
    init(_ card: MemorizeModel<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 4)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: MemorizeViewModel())
}
