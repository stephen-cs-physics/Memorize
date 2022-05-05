//
//  MemorizeApp.swift
//  Memorize
//
//  Created by stephen on 2021/10/11.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame() //class reference-> make pointer!
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
