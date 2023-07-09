//
//  NavigationSection.swift
//  TinderClone4
//
//  Created by Arjun Govind on 7/9/23.
//

import SwiftUI

import SwiftUI

struct NavigationSection: View {
    @State private var showMatches = false
    var cards: [Card] = []
    
    
    var body: some View {
        HStack {
            NavigationLink(destination: CardCustomizationScreen()) {
                Text("Customize")
            }
            
            Spacer()
            
            Button(action: {
                showMatches = true
            }) {
                Text("Matches")
            }
            .padding()
            .fullScreenCover(isPresented: $showMatches) {
                MatchesView()
            }

        }
        .padding([.horizontal, .bottom])
    }
}

struct CardCustomizationScreen : View {
    var body: some View {
        Text("Customize")
    }
}


struct NavigationSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSection()
    }
}
