//
//  MemoryGame.swift
//  Memorize
//
//  Created by H Hugo Falkman on 24/05/2020.
//  Copyright © 2020 H Hugo Falkman. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    var cards: [Card]
    
    var endOfGame: Bool {
        cards.indices.filter { !cards[$0].isMatched }.count <= 2
            && indexOfSingleFaceUpCard != nil
    }
    
    var indexOfSingleFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(matching: card),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched {
                if let matchIndex = indexOfSingleFaceUpCard {
                    if cards[chosenIndex].content == cards[matchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[matchIndex].isMatched = true
                    }
                    cards[chosenIndex].isFaceUp = true
                } else {
                    indexOfSingleFaceUpCard = chosenIndex
                }
        }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = [Card]()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var content: CardContent
        var id: Int
    }
}
