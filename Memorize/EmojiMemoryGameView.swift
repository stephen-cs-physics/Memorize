//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by stephen on 2021/10/11.
// View: equal X

import SwiftUI

struct EmojiMemoryGameView: View {
    //Array<String> == [String]
//    var emojis = ["🚕", "⌚️", "🐼", "🦊", "🐻", "🐰", "🐸", "🐹", "🐧", "🍏", "🍓", "🍈", "🍇", "🍐", "🍌", "🍍", "🏐", "🏉", "🥋", "🏸"]
    
//    @State var emojiCount = 20
    
//    @ObservedObject var viewModel: EmojiMemoryGame
    @ObservedObject var game: EmojiMemoryGame //@ObservedObject: change->rebuilt
    @Namespace private var dealingNamespace
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation(.easeInOut(duration: 5)) {
                game.shuffle()
            }
        }
    }
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totoalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    var gameBody: some View {
//        AspectVGrid(items: game.cards, aspectRatio: 2/3)  { card in
//            cardView(for: card)
                /*
            if card.isMatched && !card.isFaceUp {
//                Rectangle().opacity(0)
                Color.clear
            } else {
            CardView(card: card)
                .padding(4)
//                .aspectRatio(2/3, contentMode: .fit)
                .onTapGesture {
                    //Intents!
                    game.choose(card)
                }
            }
            */
//        }
        AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
                
        }
//        .onAppear {
//            withAnimation(.easeInOut(duration: 5)) {
//                for card in game.cards {
//                    deal(card)
//                }
//            }
//        }
        .foregroundColor(CardConstants.color)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    private struct CardConstants {
        static let color = Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totoalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
    
    var deckBody: some View {
        ZStack {
//            ForEach(game.cards.filter { isUndealt(($0) }) {card in
            ForEach(game.cards.filter(isUndealt)){ card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                deal(card)
                }
            }
        }
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack{
                gameBody
                deckBody
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
            }
        }
//        AspectVGrid(items: game.cards, aspectRatio: 2/3)  { card in
//            cardView(for: card)
            /*
            if card.isMatched && !card.isFaceUp {
                Rectangle().opacity(0)
            } else {
            CardView(card: card)
                .padding(4)
//                .aspectRatio(2/3, contentMode: .fit)
                .onTapGesture {
                    //Intents!
                    game.choose(card)
                }
            }
            */
//        }
        
        /*
        
//        VStack {
            ScrollView {
//            HStack {
//            [GridItem(.fixed(200)) or .flexible()
//                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()])
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
//                    ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
                    ForEach(game.cards) { card in
                        CardView(card: card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                //Intents!
                                game.choose(card)
                            }
                    }
        //            ForEach(emojis, id: \.self, content: { emoji in
        //                CardView(content: emoji)
        //            })
                }
                */
//            }
//            .foregroundColor(.red)
            
//            Spacer()
//            HStack{
//                remove
//                Spacer()
//                add
//            }
            
//            .font(.largeTitle)
//            .padding(.horizontal)
        .padding()
//        }
        
        
//        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View {
        if card.isMatched && !card.isFaceUp {
//            Rectangle().opacity(0)
            Color.clear
        } else {
            CardView(card: card)
                .padding(4)
                .onTapGesture {
                    game.choose(card)
                }
        }
    }
    
    /*
    var remove: some View {
        Button {
            if emojiCount > 1 {
                emojiCount -= 1
            }
        } label: {
            Image(systemName: "minus.circle")
        }
    }
    var add: some View {
        Button(action: {
            if emojiCount < emojis.count {
                emojiCount += 1
            }
        }, label: {
            Image(systemName: "plus.circle")
//            VStack {
//                Text("Remove")
//                Text("Card")
//            }
        })
    }
    */
}



struct CardView: View { //read only struct. @State 만 var로(매우 드물다). prefer not have init here
    //    var isFaceUp: Bool { return true } //or = true
//    var content: String
//    @State var isFaceUp: Bool = true
//    let card: MemoryGame<String>.Card   // part of the model: highly remommended
    let card: EmojiMemoryGame.Card
    @State private var animatedBounusRemaining: Double = 0
    
//    init(_ card: EmojiMemoryGame.Card) {
//        self.card = card
//    }
    
    var body: some View {   //shows things in the model
        
        GeometryReader(content: { geometry in
            ZStack {
                /*
                //var vs let
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
    //                shape.stroke(lineWidth: 3)
//                    Circle().padding(5).opacity(0.5)
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
                        .padding(5).opacity(0.5)
                    
                    Text(card.content).font(font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill()
                }
                */
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBounusRemaining-90)*360-90  ))
                            .onAppear {
                                animatedBounusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBounusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining-90)*360-90  ))
                    }
                }
                .padding(5)
                .opacity(0.5)
                
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
//                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
//                    .font(font(in: geometry.size))  //Not animaatable
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
                
            }
//            .modifier(Cardify(isFaceUp: card.isFaceUp))
            .cardify(isFaceUp: card.isFaceUp)
    //        .onTapGesture{
    //            isFaceUp = !isFaceUp
    //        }
        })
    }
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
//    private func font(in size: CGSize) -> Font {
//        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
//    } -> erase for animation
    
    private struct DrawingConstants {
//        static let cornerRadius: CGFloat = 20
//        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
//        EmojiMemoryGameView(game: game)
//            .preferredColorScheme(.dark)
//        EmojiMemoryGameView(game: game)
//            .preferredColorScheme(.light)
    }
}
