//
//  CardsSection.swift
//  TinderClone4
//
//  Created by Arjun Govind on 7/7/23.
//

import SwiftUI

struct CardsSection: View {
    @State private var cards: [Card] = []
    
    var body: some View {
        ZStack{
            ForEach(cards.reversed()) { card in
                    CardView(card: card)
            }
        }
        .padding(8)
        .zIndex(1.0)
        .onAppear {
            retrieveUsers { retrievedCards in
                cards = retrievedCards
            }
            
        }
    }
}

struct CardsSection_Previews: PreviewProvider {
    static var previews: some View {
        CardsSection()
    }
}
