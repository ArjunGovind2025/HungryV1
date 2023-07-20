//
//  FetchUsers.swift
//  TinderClone4
//
//  Created by Arjun Govind on 7/11/23.
//


import Firebase
import FirebaseFirestore

class FetchUsers {
    static func fetchMatchedUsers(currentUserID: String?, completion: @escaping ([String]) -> Void) {
        guard let currentUserID = currentUserID else {
            print("No current user ID")
            completion([])
            return
        }

        let db = Firestore.firestore()
        let query = db.collection("users").whereField("uid", isEqualTo: currentUserID)

        query.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let currentUserDoc = querySnapshot?.documents.first else {
                print("User's document not found")
                completion([])
                return
            }

            if let matchedUsers = currentUserDoc.data()["matches"] as? [String] {
                completion(matchedUsers)
            } else {
                print("No matched users found.")
                completion([])
            }
        }
    }

    static func fetchCards(forUserIDs userIDs: [String], completion: @escaping ([Card]) -> Void) {
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
                            completion(fetchedCards)
                        }
                    }
                } else {
                    print("Invalid data for userID \(userID)")
                }
            }
        }
    }
}
