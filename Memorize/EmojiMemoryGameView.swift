//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by H Hugo Falkman on 24/05/2020.
//  Copyright © 2020 H Hugo Falkman. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Grid(viewModel.cards) {card in
                Cardview(card: card).onTapGesture {
                    withAnimation(.linear(duration: self.chooseCardDuration)) {
                        self.viewModel.choose(card: card)
                    }
                }
                .padding(self.gridCardPadding)
            }
                .padding()
                .foregroundColor(Color.orange)
            Button(action: {
                withAnimation(.easeInOut) {
                    self.viewModel.resetGame()
                }
            }, label: { Text("New Game") })
                .foregroundColor(Color.white)
        }
    }
    
    private let gridCardPadding: CGFloat = 5
    private let chooseCardDuration = 0.75
}

struct Cardview: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining = 0.0
    
    private func startPieAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(-90), endAngle: Angle.degrees(-animatedBonusRemaining * 360 - 90), clockwise: true)
                            .onAppear {
                                self.startPieAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(-90), endAngle: Angle.degrees(-card.bonusRemaining * 360 - 90), clockwise: true)
                    }
                }
                    .padding(piePadding)
                    .opacity(pieOpacity)
                    .transition(.identity)
                Text(self.card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
                .cardify(isFaceUp: card.isFaceUp)
                .transition(.scale)
        }
    }
    
    private let piePadding: CGFloat = 5
    private let pieOpacity = 0.4
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[1])
        return EmojiMemoryGameView(viewModel: game)
    }
}
