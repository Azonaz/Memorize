import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = MemorizeViewModel()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
