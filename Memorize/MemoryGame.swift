//
//  MemoryGame.swift
//  Memorize
//
//  Created by stephen on 2022/04/29.
//  Model

import Foundation   // Basic struct(array...)

struct MemoryGame<CardContent> where CardContent: Equatable{ //Generic
    private(set) var cards: Array<Card>  //MemoryGame.Card
    //private(set): only choose can change faceup/matched...
    
    
    //willSet -> newValue , didSet -> oldValue
    //should sink with cards and indexOf~  --> computed value
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            //compute
//            let faceUpCardIndeces = cards.indices.filter({ cards[$0].isFaceUp })
//            return faceUpCardIndeces.oneAndOnly
            
            cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly
            
            //filter
//            var faceUpCardIndices = [Int]()
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    faceUpCardIndices.append(index)
//                }
//            }
            
            //extension
//            if faceUpCardIndices.count == 1 {
//                return faceUpCardIndices.first
//            } else {
//                return nil
//            }
            
        }
        set {
            cards.indices.forEach{cards[$0].isFaceUp = ($0 == newValue)}
            
//            for index in cards.indices {
////                if index != indexOfTheOneAndOnlyFaceUpCard {
//                cards[index].isFaceUp = (index == newValue)
//                if index != newValue {
//                    cards[index].isFaceUp = false
//                } else {
//                    cards[index].isFaceUp = true
//                }
//            }
            
        }
    }
    
    
    mutating func choose(_ card: Card){
//        if let chosenIndex = index(of: card) {
//        if let chosenIndex = cards.firstIndex(where: { aCardInTheCardsArray in aCardInTheCardsArray.id == card.id }) {
        //not && -> ,
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) ,
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {   //where CardContent: Equatable
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
//                indexOfTheOneAndOnlyFaceUpCard = nil
                cards[chosenIndex].isFaceUp = true
            } else {
//                for index in cards.indices {
//                    cards[index].isFaceUp = false
//                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            
//        var chosenCard = cards[chosenIndex] //make copy! -> wrong!
//        cards[chosenIndex].isFaceUp.toggle()
            
//        print("chosenCard = \(chosenCard)")
        }
        print("\(cards)")
    }
    /*
    func index(of card : Card) -> Int? {
        for index in 0..<cards.count {
            if cards[index].id == card.id {
                return index
            }
        }
//        return 0    //bogus! -> Int?
        return nil
    }
    */
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) { //loose free init
//        cards = Array<Card>()
        cards = []
        //add numberOfPairsOfCards * 2 cards to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)     //functional programming
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
//        var id: ObjectIdentifier
        //MemoryGame.Card,  outside: 포커 게임 등이 있을 때 nesting
//        var isFaceUp: Bool = false
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
        let content: CardContent     //extension: not only emoji -> don't care: <>
        let id: Int
        
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

extension Array {
    var oneAndOnly: Element? {
        //should be coumputed var! in extension
        if count == 1 { //self.count
            return first
        } else {
            return nil
        }
    }
}
