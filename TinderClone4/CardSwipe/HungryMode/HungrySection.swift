//
//  HungrySection.swift
//  TinderClone4
//
//  Created by Arjun Govind on 7/13/23.
//


import SwiftUI
import Firebase
import FirebaseFirestore

struct HungrySection: View {
    @State private var cards: [Card] = []
    @State private var fetchedMatchedUsers: [String] = []

    var body: some View {
        ZStack {
            ForEach(cards.reversed()) { card in
                HungryModeView(card: card)
            }
        }
        .padding(8)
        .zIndex(1.0)
        .onAppear {
            guard let currentUserID = Auth.auth().currentUser?.uid else {
                print("No current user ID")
                return
            }

            FetchUsers.fetchMatchedUsers(currentUserID: currentUserID) { matchedUsers in
                FetchUsers.fetchCards(forUserIDs: matchedUsers) { fetchedCards in
                    cards = fetchedCards
                }
            }
        }
    }
}

struct HungrySection_Previews: PreviewProvider {
    static var previews: some View {
        HungrySection()
    }
}

