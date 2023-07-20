//
//  MatchesView.swift
//  TinderClone4
//
//  Created by Arjun Govind on 7/8/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct MatchesView: View {
    // State variables
    @State private var currentUserID: String? = nil
    @State private var fetchedMatchedUsers: [String] = []
    @State public var cards: [Card] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Matched Users")
                    .font(.title)
                    .fontWeight(.bold)

                ScrollView(.horizontal) {
                    LazyHStack(spacing: 16) {
                        ForEach(cards, id: \.id) { card in
                            VStack(spacing: 8) {
                                if let image = card.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 350)
                                        .cornerRadius(8)
                                } else {
                                    // Handle the case when the image is not available
                                    Color.gray
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(8)
                                }

                                VStack(alignment: .leading) {
                                    Text(card.name)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    Text("\(card.age)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                                .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationBarBackButtonHidden(true)

        }
        .onAppear {
            // Fetch matched users on view appear
            currentUserID = Auth.auth().currentUser?.uid
            fetchMatchedUsers()
        }
    }

    // Fetch matched users from Firestore
    func fetchMatchedUsers() {
        guard let currentUserID = currentUserID else {
            print("No current user ID")
            return
        }

        let db = Firestore.firestore()
        let query = db.collection("users").whereField("uid", isEqualTo: currentUserID)

        query.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }

            guard let currentUserDoc = querySnapshot?.documents.first else {
                print("User's document not found")
                return
            }

            if let matchedUsers = currentUserDoc.data()["matches"] as? [String] {
                self.fetchCards(forUserIDs: matchedUsers)
            } else {
                print("No matched users found.")
            }
        }
    }

    // Fetch cards for the given user IDs
    func fetchCards(forUserIDs userIDs: [String]) {
        let db = Firestore.firestore()
        var fetchedCards: [Card] = []

        for userID in userIDs {
            let query = db.collection("users").whereField("uid", isEqualTo: userID)

            query.getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching documents for userID \(userID): \(error.localizedDescription)")
                    return
                }

                guard let document = querySnapshot?.documents.first else {
                    print("Document does not exist for userID \(userID)")
                    return
                }

                let data = document.data()

                if let name = data["firstname"] as? String,
                   let imageName = data["image_url"] as? String,
                   let bio = data["about"] as? String {

                    loadImage(withURL: imageName) { image in
                        let card = Card(id: userID, name: name, imageName: imageName, image: image, age: 17, bio: bio)
                        fetchedCards.append(card)

                        if fetchedCards.count == userIDs.count {
                            self.cards = fetchedCards
                        }
                    }
                } else {
                    print("Invalid data for userID \(userID)")
                }
            }
        }
    }

}

struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
    }
}









