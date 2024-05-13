import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: MemorizeViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.currentTheme.name)
                .foregroundColor(viewModel.checkColor())
            Spacer()
            Text("Score: \(viewModel.gameScore ?? 0)")
                .foregroundColor(.black)
        }
        .font(.title)
        .padding(.horizontal, 30)
        VStack {
            ScrollView {
                cards
                    .animation(.default, value: viewModel.cards)
            }
            Button(action: {
                viewModel.selectRandomTheme()
                viewModel.shuffle()
            }, label: {
                ZStack {
                    Rectangle()
                        .frame(width: 200, height: 50)
                        .foregroundColor(.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(viewModel.checkColor(), lineWidth: 1)
                        )
                    Text("New game")
                        .foregroundColor(.black)
                        .font(.title)
                }
            })
        }
        .onAppear() {
            viewModel.shuffle()
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 4)], spacing: 4) {
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .padding(16)
        .foregroundColor(viewModel.checkColor())
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
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: MemorizeViewModel())
}
