//
//  ProfileView.swift
//  TinderClone4
//
//  Created by Arjun Govind on 7/19/23.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @State private var currentUserID: String? = nil
    @State private var userProfileCard: Card?
    @State private var name: String = ""
    @State private var age: Int = 0
    @State private var bio: String = ""
    @State private var isEditing: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                if let card = userProfileCard {
                    ProfileCardView(card: card)
                        .padding()
                }

                VStack {
                    Text("Edit Profile")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()

                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Stepper(value: $age, in: 18...100, step: 1) {
                        Text("Age: \(age)")
                    }
                    .padding()

                    TextEditor(text: $bio)
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .padding()
                }
                .padding()

                Button(action: saveProfile) {
                    Text("Save")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(!isEditing || fieldsAreEmpty())
            }
        }
        .onAppear {
            currentUserID = Auth.auth().currentUser?.uid
            fetchUserProfileCard()
        }
        .onChange(of: name, perform: { _ in
            isEditing = true
        })
        .onChange(of: age, perform: { _ in
            isEditing = true
        })
        .onChange(of: bio, perform: { _ in
            isEditing = true
        })
    }

    private func fetchUserProfileCard() {
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

            let data = currentUserDoc.data()

            if let name = data["firstname"] as? String,
               let imageName = data["image_url"] as? String,
               let bio = data["about"] as? String {
                self.name = name
                self.age = 17 // Set the initial age value
                self.bio = bio

                loadImage(withURL: imageName) { image in
                    let card = Card(id: currentUserID, name: name, imageName: imageName, image: image, age: 17, bio: bio)
                    self.userProfileCard = card
                }
            } else {
                print("Invalid data for userID \(currentUserID)")
            }
        }
    }

    private func saveProfile() {
        guard let currentUserID = currentUserID else {
            print("No current user ID")
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").whereField("uid", isEqualTo: currentUserID)

        // Only update fields if changes have been made and no field is left blank
        if isEditing && !fieldsAreEmpty() {
            userRef.getDocuments { snapshot, error in
                if let error = error {
                    print("Error updating profile: \(error.localizedDescription)")
                    return
                }

                guard let document = snapshot?.documents.first else {
                    print("User's document not found")
                    return
                }

                document.reference.updateData([
                    "firstname": name,
                    "age": age,
                    "about": bio
                ]) { error in
                    if let error = error {
                        print("Error updating profile: \(error.localizedDescription)")
                    } else {
                        print("Profile updated successfully")
                        isEditing = false
                    }
                }
            }
        }
    }

    private func fieldsAreEmpty() -> Bool {
        return name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            bio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}



struct ProfileCardView: View {
    let card: Card

    var body: some View {
        ZStack(alignment: .center) {
            if let image = card.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 300)
                    .cornerRadius(8)
                    .overlay(
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(card.name)
                                .font(.title)
                                
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal)

                            Text(String(card.age))
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)

                            Text(card.bio)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity, alignment: .bottomLeading)
                        .padding()
                    )
            } else {
                Color.gray
                    .frame(width: 180, height: 300)
                    .cornerRadius(8)
            }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
