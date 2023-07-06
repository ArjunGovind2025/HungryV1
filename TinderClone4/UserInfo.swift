//
//  UserInfo.swift
//  TinderClone4
//
//  Created by Arjun Govind on 7/5/23.
//
import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseCore

struct UserInfo: View {
    @State private var formData = FormData()
    @AppStorage("uid") var userID: String = ""
    
    var body: some View {
        VStack {
            // ... Code for Nav component
            
            VStack {
                Text("CREATE ACCOUNT")
                    .font(.title)
                
                Form {
                    Section {
                        TextField("First Name", text: $formData.first_name)
                        
                        HStack {
                            TextField("DD", text: $formData.dob_day)
                            TextField("MM", text: $formData.dob_month)
                            TextField("YYYY", text: $formData.dob_year)
                        }
                        
                        Text("Gender")
                        
                        VStack {
                            RadioButton(id: "man", label: "Man", isSelected: $formData.gender_identity)
                            RadioButton(id: "woman", label: "Woman", isSelected: $formData.gender_identity)
                            RadioButton(id: "other", label: "Other", isSelected: $formData.gender_identity)
                        }
                        
                        Toggle("Show Gender on my Profile", isOn: $formData.show_gender)
                        
                        Text("Show Me")
                        
                        VStack {
                            RadioButton(id: "man", label: "Man", isSelected: $formData.gender_interest)
                            RadioButton(id: "woman", label: "Woman", isSelected: $formData.gender_interest)
                            RadioButton(id: "everyone", label: "Everyone", isSelected: $formData.gender_interest)
                        }
                        
                        TextField("About me", text: $formData.about)
                    }
                    
                    Section {
                        TextField("Profile Photo URL", text: $formData.url)
                        
                        if !formData.url.isEmpty {
                            Image(uiImage: UIImage(imageLiteralResourceName: formData.url))
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        }
                    }
                }
                
                Button("Submit") {
                    handleSubmit()
                }
            }
            Button(action: {
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    withAnimation {
                        userID = ""
                    }
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
            }) {
                Text("Sign Out")
            }
        }
    }
    
    func handleSubmit() {
        let db = Firestore.firestore()
        
        //STRIP WHITE SPACES!!!!!!!!!!!!!!
        
        db.collection("users").addDocument(data: ["firstname": formData.first_name, "dob_day": formData.dob_day,"dob_month": formData.dob_month, "dob_year": formData.dob_year,"gender": formData.gender_identity, "about": formData.about, "uid": userID]){(error) in
            
            if error != nil{
                print("Error saving data. Try again.")
            }
        }
        
        
        
        // Handle form submission
        print("Submitted")
        
        // Example axios.put() call
        // axios.put('http://localhost:8000/user', formData)
        
        // Example navigation to dashboard
        // navigate('/dashboard')
    }
}

struct RadioButton: View {
    let id: String
    let label: String
    @Binding var isSelected: String
    
    var body: some View {
        Button(action: {
            isSelected = id
        }) {
            HStack {
                Image(systemName: isSelected == id ? "circle.fill" : "circle")
                Text(label)
            }
        }
    }
}


struct FormData {
    var user_id: String?
    var first_name: String = ""
    var dob_day: String = ""
    var dob_month: String = ""
    var dob_year: String = ""
    var show_gender: Bool = false
    var gender_identity: String = "man"
    var gender_interest: String = "woman"
    var url: String = ""
    var about: String = ""
    var matches: [String] = []
}

