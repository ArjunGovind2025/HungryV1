// RightSwipe.swift
// TinderClone4
//
// Created by Arjun Govind on 7/7/23.

import Foundation
import Firebase


func rightSwipe(swipedProfileID: String, completion: @escaping (Error?) -> Void) {
    guard let currentUserID = Auth.auth().currentUser?.uid else {
        completion(nil)
        return
    }
    
    let db = Firestore.firestore()
    
    // Combine the currentUserQuery and swipedUserQuery into a single query
    let query = db.collection("users").whereField("uid", in: [currentUserID, swipedProfileID])
    
    query.getDocuments { (querySnapshot, error) in
        if let error = error {
            print("Error fetching documents: \(error.localizedDescription)")
            completion(error)
            return
        }
        
        guard let currentUserDoc = querySnapshot?.documents.first(where: { $0["uid"] as? String == currentUserID }),
              let swipedUserDoc = querySnapshot?.documents.first(where: { $0["uid"] as? String == swipedProfileID }) else {
            print("User's documents not found")
            completion(nil)
            return
        }
        
        let currentUserRef = currentUserDoc.reference
        let swipedUserRef = swipedUserDoc.reference
        
        let batch = db.batch()
        
        if let swipedUserLikes = swipedUserDoc["likes"] as? [String],
           swipedUserLikes.contains(currentUserID) {
            print("FOUND MATCH")
            print(swipedUserLikes)
            
            // Update likes and matches of current user
            batch.updateData(["likes": FieldValue.arrayUnion([swipedProfileID]),
                              "matches": FieldValue.arrayUnion([swipedProfileID])], forDocument: currentUserRef)
            // Update matches of swiped user
            batch.updateData(["matches": FieldValue.arrayUnion([currentUserID])], forDocument: swipedUserRef)
        } else {
            // Update likes of current user
            print("ONLY ONEWAY LIKE")
            batch.updateData(["likes": FieldValue.arrayUnion([swipedProfileID])], forDocument: currentUserRef)
        }
        
        // Commit the batched write operation
        batch.commit { (error) in
            if let error = error {
                print("Error updating documents: \(error.localizedDescription)")
                completion(error)
            } else {
                if let swipedUserLikes = swipedUserDoc["likes"] as? [String],
                   swipedUserLikes.contains(currentUserID) {
                    // The "likes" array contains the specific user
                    print("It's a match!")
                }
                completion(nil)
            }
        }
    }
}



