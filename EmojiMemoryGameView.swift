//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Vicente Montoya on 8/4/20.
//  Copyright © 2020 Vicente Montoya. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    var body: some View {
        VStack {
            
            // MARK: - Title
            GeometryReader{ geometry in
                HStack(spacing: 0){
                    Text("Score: \(self.viewModel.score)").font(Font.headline).padding()
                        .frame(width: (geometry.size.width / 3), height: (geometry.size.height / 5), alignment: .leading)
                    
                    Text(self.viewModel.theme.name).font(Font.title).padding()
                        .frame(width: (geometry.size.width / 3), height: (geometry.size.height / 5), alignment: .center)
                    
                    Button("New Game"){
                        withAnimation(.easeInOut(duration: 0.5)){
                            self.newGame()
                        }
                    }.padding()
                        .frame(width: (geometry.size.width / 3), height: (geometry.size.height / 5), alignment: .trailing)
                    
                }
                
            }.padding([.leading, .trailing, .bottom], self.outerGridPadding)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 15)
            
            //MARK: - Cards
            Grid(items: self.viewModel.cards, aspectRatio: self.aspectRatio){ card in
                
                CardView(card: card).padding(self.innerGridPadding)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)){
                            self.viewModel.choose(card: card)
                        }
                }
                
            }
            .padding([.leading, .trailing, .bottom], self.outerGridPadding)
            .foregroundColor(Color(UIColor(self.viewModel.theme.foregroundColor)))
            
        }
        .foregroundColor(Color(UIColor(self.viewModel.theme.foregroundColor)))
    }
    
    // MARK: - Drawing constants
    private let outerGridPadding: CGFloat = 5
    private let innerGridPadding: CGFloat = 3
    private let aspectRatio: CGFloat = 0.667
    
    private func newGame(){
        //self.viewModel.newGame(theme: themes[Int.random(in: 0..<themes.count)])
    }
}


struct CardView:View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader{ geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation(){
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration : card.bonusTimeRemaining)){
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View{
        if card.isFaceUp || !card.isMatched{
            ZStack {
                
                Group{
                    if card.isConsumingBonusTime{
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (-animatedBonusRemaining * 360) - 90), clockwise: true)
                            .onAppear(){
                                self.startBonusTimeAnimation()
                        }
                    } else{
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (-card.bonusRemaining * 360) - 90), clockwise: true)
                    }
                    
                }.padding(5).opacity(0.4)
                
                Text(card.content)
                    .font(Font.system(size: min(size.width, size.height) * fontScaleFactor))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .transition(.scale)
                    .animation(card.isMatched ? Animation.linear(duration: 2).repeatForever(autoreverses: false) : .default)
                
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(.move(edge: .bottom))
        }
    }
    
    
    private let fontScaleFactor: CGFloat = 0.70
}
