//
//  RetrieveUser.swift
//  TinderClone4
//
//  Created by Arjun Govind on 7/7/23.
//

import FirebaseFirestore
import FirebaseStorage
import Firebase

func retrieveUsers(completion: @escaping ([Card]) -> Void) {
    let db = Firestore.firestore()
    var cards: [Card] = []
    
    db.collection("users").getDocuments { (snapshot, error) in
        if let error = error {
            print("Error retrieving users: \(error.localizedDescription)")
            completion([])
            return
        }
        
        guard let documents = snapshot?.documents else {
            print("No users found")
            completion([])
            return
        }
        
        // Iterate through each document in the snapshot
        for document in documents {
            let data = document.data()
            
            // Access the attributes of each user document
            if let firstName = data["firstname"] as? String,
               let about = data["about"] as? String,
               let uid = data["uid"] as? String,
               let imageURL = data["image_url"] as? String{
                
                
                // Create a Card object with the user's attributes
                var card = Card(id: uid, name: firstName, imageName: imageURL, age: 21, bio: about)

                
                loadImage(withURL: imageURL) { image in
                    // Set the image of the card
                    card.image = image
                    cards.append(card)
                    // Append the card to the list
                    if cards.count == documents.count {
                    // Call the completion handler with the retrieved cards
                        completion(cards)
                    }
                }
                
                
            }
            
            // Call the completion handler with the retrieved cards
    
        }
    }
}

func loadImage(withURL url: String, completion: @escaping (UIImage?) -> Void) {
    let storage = Storage.storage()
    let storageRef = storage.reference(forURL: url)
    
    storageRef.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
        guard let data = data, error == nil else {
            print("Error loading image: \(error?.localizedDescription ?? "")")
            completion(nil)
            return
        }
        
        let imageCard = UIImage(data: data)
        completion(imageCard)
    }
}

func retrieveUsersByID(userIDs: [String], completion: @escaping ([Card]) -> Void) {
    let db = Firestore.firestore()
    var cards: [Card] = []
    
    // Create a DispatchGroup to handle the asynchronous fetching of cards
    let group = DispatchGroup()
    
    // Iterate through each user ID
    for userID in userIDs {
        group.enter()
        
        // Fetch the user document for the given user ID
        let userRef = db.collection("users").document(userID)
        userRef.getDocument { (documentSnapshot, error) in
            defer {
                group.leave()
            }
            
            if let error = error {
                print("Error retrieving user document for userID: \(userID), \(error.localizedDescription)")
                return
            }
            
            guard let documentData = documentSnapshot?.data() else {
                print("User document not found for userID: \(userID)")
                return
            }
            
            // Access the attributes of the user document
            if let firstName = documentData["firstname"] as? String,
               let about = documentData["about"] as? String,
               let imageURL = documentData["image_url"] as? String {
                
                // Create a Card object with the user's attributes
                var card = Card(id: userID, name: firstName, imageName: imageURL, age: 21, bio: about)
                
                // Load the image asynchronously
                loadImage(withURL: imageURL) { image in
                    // Set the image of the card
                    card.image = image
                    
                    // Append the card to the list
                    cards.append(card)
                }
            }
        }
    }
    
    // Notify the completion handler when all cards have been fetched
    group.notify(queue: .main) {
        // Call the completion handler with the retrieved cards
        completion(cards)
    }
}

func searchUsersByUID(uids: [String], completion: @escaping ([Card]) -> Void) {
    let db = Firestore.firestore()
    var cards: [Card] = []
    
    let dispatchGroup = DispatchGroup()
    
    for uid in uids {
        dispatchGroup.enter()
        
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { documentSnapshot, error in
            defer {
                dispatchGroup.leave()
            }
            
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                return
            }
            
            guard let documentData = documentSnapshot?.data(),
                  let name = documentData["name"] as? String,
                  let imageName = documentData["imageName"] as? String,
                  let age = documentData["age"] as? Int,
                  let bio = documentData["bio"] as? String else {
                return
            }
            
            let card = Card(id: uid, name: name, imageName: imageName, age: age, bio: bio)
            cards.append(card)
        }
    }
    
    dispatchGroup.notify(queue: .main) {
        completion(cards)
    }
}

func retrieveCard(forUserID userID: String, completion: @escaping (Card?) -> Void) {
    let db = Firestore.firestore()
    let userRef = db.collection("users").document(userID)
    
    userRef.getDocument { documentSnapshot, error in
        if let error = error {
            print("Error retrieving document for userID \(userID): \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        guard let data = documentSnapshot?.data(),
              let name = data["name"] as? String,
              let imageName = data["imageName"] as? String,
              let age = data["age"] as? Int,
              let bio = data["bio"] as? String else {
            print("Invalid data for userID \(userID)")
            completion(nil)
            return
        }
        
        loadImage(withURL: imageName) { image in
            let card = Card(id: userID, name: name, imageName: imageName, image: image, age: age, bio: bio)
            completion(card)
        }
    }
}

