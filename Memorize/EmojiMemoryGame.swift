//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by H Hugo Falkman on 24/05/2020.
//  Copyright © 2020 H Hugo Falkman. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model = createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["👻", "🎃", "🕷", "😱", "☠️", "🙀"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            emojis[pairIndex]
        }
    }
        
    // MARK: - Access to the Model
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        if model.endOfGame {
            model = EmojiMemoryGame.createMemoryGame()
        } else {
            model.choose(card: card)
        }
    }
}
