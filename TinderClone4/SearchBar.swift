//
//  SearchBar.swift
//  TinderClone4
//
//  Created by Arjun Govind on 7/17/23.
//

import SwiftUI
import FirebaseFirestore

struct SearchBarView: View {
    @State private var searchQuery = ""
    @State private var matchingUsers: [User] = []

    var body: some View {
        VStack {
            TextField("Search by name", text: $searchQuery)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
                .onChange(of: searchQuery) { newValue in
                    searchUsers()
                }

            List(matchingUsers, id: \.id) { user in
                Text(user.name)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
            }
            .listStyle(PlainListStyle())
        }
    }

    func searchUsers() {
        let db = Firestore.firestore()

        db.collection("users")
            .whereField("firstname", isGreaterThanOrEqualTo: searchQuery)
            .whereField("firstname", isLessThan: searchQuery + "z")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error searching users: \(error.localizedDescription)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No matching users found.")
                    return
                }

                let users = documents.compactMap { document -> User? in
                    let data = document.data()
                    let name = data["name"] as? String
                    let id = document.documentID
                    return name != nil ? User(id: id, name: name!) : nil
                }

                matchingUsers = users
            }
    }
}

struct User: Identifiable {
    let id: String
    let name: String
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}

