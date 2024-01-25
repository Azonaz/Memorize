import SwiftUI

struct ContentView: View {
    @State var emojis: [String] = []
    let emojisAnimal = ["🐱", "🐥", "🐙", "🐼", "🦩", "🐑", "🐭", "🐳"]
    let emojisFood = ["🥐", "🧁", "☕️", "🍕", "🍦", "🍜", "🍔", "🍗"]
    let emojisTransport = ["🚁", "🚘", "✈️", "⛵️", "🚂", "🚜", "🛵", "🚚"]
    
    @State var cartCount: Int = 4
    @State var selectedCategory: EmojiCategory = .animal
    
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
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
            ForEach(0..<emojis.count, id: \.self) { index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(.orange)
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
        switch selectedCategory {
        case .animal:
            combinedEmojis = emojisAnimal + emojisAnimal
        case .food:
            combinedEmojis = emojisFood + emojisFood
        case .transport:
            combinedEmojis = emojisTransport + emojisTransport
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
