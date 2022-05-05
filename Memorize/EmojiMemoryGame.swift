//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by stephen on 2022/04/29.
// ViewModel: Gatekeeper->private (access control)

//import Foundation
import SwiftUI

//func makeCardContent(index: Int) -> String {
//    return "😀"
//}

class EmojiMemoryGame: ObservableObject {
    //static: create once in entire project (ex: .white) vs. public:
    typealias Card = MemoryGame<String>.Card
    
    //static: type property, type vaiable
    private static let emojis = ["🚕", "⌚️", "🐼", "🦊", "🐻", "🐰", "🐸", "🐹", "🐧", "🍏", "🍓", "🍈", "🍇", "🍐", "🍌", "🍍", "🏐", "🏉", "🥋", "🏸"]
    //type function: the 'very' type function of the class
    private static func createMemoryGame() -> MemoryGame<String> {
        //return 생략
        MemoryGame<String> (numberOfPairsOfCards: 5) { pairIndex in
//            EmojiMemoryGame.emojis[pairIndex]
            emojis[pairIndex]  //static inside static: can remove
        }
    }
    
//    var objectWillChange: ObservableObjectPublisher   //don't need to do cuase auto.
    
    /*
//    private var model: MemoryGame<String> = MemoryGame<String> (numberOfPairsOfCards: 4, createCardContent: { (index: Int) -> String in
//    private var model: MemoryGame<String> = MemoryGame<String> (numberOfPairsOfCards: 4) { _ in  "😀" } //_ : don't matter
    private var model: MemoryGame<String> = MemoryGame<String> (numberOfPairsOfCards: 4) { pairIndex in
        EmojiMemoryGame.emojis[pairIndex]
        //property: var, let, property initializer: assign
        
    } //_ : don't matter what's in
    //private(set): can look but can't change
*/
    @Published private var model = createMemoryGame()  //EmojiMemoryGame.create.() 생략 가능
        
    var cards: Array<Card> {
        model.cards
    }
    
    // MARK - Intent(s)
    
    func choose(_ card: Card) {
//        objectWillChange.send() //send to the world! -> @Published do auto.
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
