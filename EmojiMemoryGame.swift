//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Vicente Montoya on 8/9/20.
//  Copyright © 2020 Vicente Montoya. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject{
    @Published private var model: MemoryGame<String>
    private(set) var theme: Theme
    
    init(theme: Theme){
        self.theme = theme
        var emojis = theme.content
        emojis.shuffle()
        let numberOfPairsOfCards = theme.numberOfPairsOfCards ?? 10
        self.model = MemoryGame<String>(numberOfPairsOfCards: numberOfPairsOfCards) {pairIndex in emojis[pairIndex] }
        
        let encodedTheme: String = ((try? JSONEncoder().encode(theme))?.utf8!)!
        print(encodedTheme)
    }
    
    //MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String>.Card>{
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    //MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func newGame(theme: Theme){
        self.theme = theme
        var emojis = theme.content
        emojis.shuffle()
        let numberOfPairsOfCards = theme.numberOfPairsOfCards ?? 10
        self.model = MemoryGame<String>(numberOfPairsOfCards: numberOfPairsOfCards) {pairIndex in emojis[pairIndex] }
    }
}

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}
