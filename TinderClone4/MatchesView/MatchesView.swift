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
    @State private var imageCards: [String: UIImage] = [:]
    
    // Computed property for matched users
    var matchedUsers: [String] {
        fetchedMatchedUsers
    }
    
    var body: some View {
        VStack {
            Text("Matched Users")
                .font(.title)
                .fontWeight(.bold)
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(matchedUsers, id: \.self) { userID in
                        Group {
                            if let image = imageCards[userID] {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(8)
                            } else {
                                Color.gray
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                            }
                        }
                        .onAppear {
                            loadImage(withURL: userID) { image in
                                imageCards[userID] = image
                                print("Image loaded for userID: \(userID)")
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            // Fetch matched users on view appear
            currentUserID = Auth.auth().currentUser?.uid
            fetchMatchedUsers { matchedUsers in
                if let users = matchedUsers {
                    // `users` is unwrapped and can be used as `[String]`
                    print("Matched users: \(users)")
                } else {
                    // Handle the case when matchedUsers is nil
                    print("No matched users found.")
                }
            }

        }
    }
    
    // Fetch matched users from Firestore using completion handler
    func fetchMatchedUsers(completion: @escaping ([String]?) -> Void) {
        guard let currentUserID = currentUserID else {
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        let query = db.collection("users").whereField("uid", isEqualTo: currentUserID)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let currentUserDoc = querySnapshot?.documents.first(where: { $0["uid"] as? String == currentUserID }) else {
                print("User's document not found")
                completion(nil)
                return
            }
            
            let currentUserRef = currentUserDoc.reference
            
            currentUserRef.getDocument { (documentSnapshot, error) in
                if let error = error {
                    print("Error fetching user document: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                if let matchedUsers = documentSnapshot?.data()?["matches"] as? [String] {
                    completion(matchedUsers)
                } else {
                    completion([])
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



