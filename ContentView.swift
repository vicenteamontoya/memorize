//
//  ContentView.swift
//  Memorize
//
//  Created by Vicente Montoya on 8/4/20.
//  Copyright © 2020 Vicente Montoya. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    var viewModel: EmojiMemoryGame
    var fontSize: Font {viewModel.cards.count/2 < 5 ? Font.largeTitle : Font.title}
    var body: some View {
        HStack{
            ForEach(viewModel.cards){ card in
                CardView(card: card).onTapGesture {
                    self.viewModel.choose(card: card)
                }
            }
        }
        .padding()
        .foregroundColor(Color.orange)
        .font(fontSize)
    }
}

struct CardView:View {
    var card: MemoryGame<String>.Card
   
    var body: some View {
        ZStack{
            if(card.isFaceUp){
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke()
                Text(card.content)
            }
            else{
                RoundedRectangle(cornerRadius: 10.0).fill(Color.orange)
            }
        }
        .aspectRatio(0.66, contentMode: .fit)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
