//
//  MemoryGame.swift
//  Memorize
//
//  Created by Vicente Montoya on 8/9/20.
//  Copyright © 2020 Vicente Montoya. All rights reserved.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    var score: Int = 0
    
    private var indexOfUpCard: Int? {
        get{
            cards.indices.filter{ index in cards[index].isFaceUp }.only
        }
        
        set{
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched{
            if let potentialMatchedIndex = indexOfUpCard{
                if cards[chosenIndex].content == cards[potentialMatchedIndex].content{
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchedIndex].isMatched = true
                    increaseScore()
                }
                else{
                    if(self.cards[chosenIndex].hasBeenFaceUp){
                        decreaseScore()
                    }
                    if(self.cards[potentialMatchedIndex].hasBeenFaceUp){
                        decreaseScore()
                    }
                }
                self.cards[chosenIndex].isFaceUp = true
                self.cards[chosenIndex].hasBeenFaceUp = true
                self.cards[potentialMatchedIndex].hasBeenFaceUp = true
            } else{
                indexOfUpCard = chosenIndex
            }
        }
    }
    
    mutating func increaseScore(by amount: Int = 2){
        self.score += amount
    }
    
    mutating func decreaseScore(by amount: Int = 1){
        self.score -= amount
    }
        
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet{
                if isFaceUp{
                   startUsingBonusTime()
                }else{
                    stopUsingBonusTime()
                }
            }
        }
        
        var isMatched: Bool = false {
            didSet{
                stopUsingBonusTime()
            }
        }
        
        var hasBeenFaceUp: Bool = false
        
        var content: CardContent
        
        var id: Int
    
        
        // MARK: = Bonus time
        
        var bonusTimeLimit: TimeInterval = 6
    
        private var faceUpTime: TimeInterval{
            if let lastFaceUpDate = self.lastFaceUpDate{
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else{
               return pastFaceUpTime
            }
        }
    
        var lastFaceUpDate: Date?
        
        var pastFaceUpTime: TimeInterval = 0
        
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime(){
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
