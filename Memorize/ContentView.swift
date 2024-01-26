import SwiftUI

struct ContentView: View {
    @State var emojis: [String] = []
    let emojisAnimal = ["🐱", "🐥", "🐙", "🐼", "🦩", "🐑", "🐭", "🐳", "🐍", "🦋"]
    let emojisFood = ["🥐", "🧁", "☕️", "🍕", "🍦", "🍜", "🍔", "🍗", "🍧", "🍳", "🥗"]
    let emojisTransport = ["🚁", "🚘", "✈️", "⛵️", "🚂", "🚜", "🛵", "🚚", "🚲", "🛥️"]
    
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
            Spacer()
            cardAdjusters
        }
        .padding()
        .onAppear {
            updateEmojis()
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: widthThatBestFits()))]) {
            ForEach(0..<emojis.count, id: \.self) { index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
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
    
    func widthThatBestFits() -> CGFloat {
        let cardCount = emojis.count
        
        if cardCount == 8 {
            return 90
        } else if cardCount < 16 {
            return 80
        } else {
            return 65
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
            randomCount = Int.random(in: 4...emojisAnimal.count)
            let selectedEmojis = Array(emojisAnimal.shuffled().prefix(randomCount))
            combinedEmojis = selectedEmojis + selectedEmojis
            cardColor = .orange
        case .food:
            randomCount = Int.random(in: 4...emojisFood.count)
            let selectedEmojis = Array(emojisFood.shuffled().prefix(randomCount))
            combinedEmojis = selectedEmojis + selectedEmojis
            cardColor = .green
        case .transport:
            randomCount = Int.random(in: 4...emojisTransport.count)
            let selectedEmojis = Array(emojisTransport.shuffled().prefix(randomCount))
            combinedEmojis = selectedEmojis + selectedEmojis
            cardColor = .red
        }
        emojis = combinedEmojis.shuffled()
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
    let content: String
    @State var isFaceUp: Bool = false
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 4)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
