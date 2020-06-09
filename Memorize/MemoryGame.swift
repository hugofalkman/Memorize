//
//  MemoryGame.swift
//  Memorize
//
//  Created by H Hugo Falkman on 24/05/2020.
//  Copyright © 2020 H Hugo Falkman. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: [Card]
    
//    var endOfGame: Bool { // private(set) doesn't apply to read only computed vars
//        cards.indices.filter { !cards[$0].isMatched }.count <= 2
//            && indexOfSingleFaceUpCard != nil
//    }
    
    private var indexOfSingleFaceUpCard: Int? {
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
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if user matches the card
        // before a certain amount of time passes, during which the card is face up
        
        // can be zero meaning "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // last time this card was turned face up (while it's still face up)
        var lastFaceUpDate: Date?
        // accumulated time this card has been face up
        // (not including the current face up time, if it's still face up)
        var pastFaceUpTime: TimeInterval = 0
        
        // time left before bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // % of bonus time remaining
        var bonusRemaining: Double {
            bonusTimeLimit > 0 && bonusTimeRemaining > 0 ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        // was card matched during bonus time period?
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // currently faceup, unmatched, and not yet used up bonus time
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when card transitions from face up state
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
}
