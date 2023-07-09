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
import PhotosUI

struct UserInfo: View {
    @State var formData = FormData()
    @AppStorage("uid") var userID: String = ""
    @AppStorage("UIBool") var userInfoBool: Bool = false
    @State private var ImagePickerPresented: Bool = false
    @State private var photoItem: PhotosPickerItem?
    @State private var photoImage: UIImage?
    @State private var uiImage: UIImage?
    
    var body: some View {
        VStack {
            VStack {
                Text("CREATE ACCOUNT")
                    .font(.title)
                
                List {
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
                        Button(action: {
                            ImagePickerPresented = true
                        }) {
                            Text("Profile Photo URL")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .photosPicker(isPresented: $ImagePickerPresented, selection: $photoItem, matching: .images)
                        .onChange(of: photoItem) { _ in
                            Task {
                                if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        photoImage = UIImage(data: data)
                                        return
                                    }
                                }

                                print("Failed")
                            }
                        }
                        }
                    }
                    
                    Button("Submit") {
                        Task {
                            await handleSubmit()
                        }
                    }
                }
                
                Button(action: {
                    userInfoBool = false
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
        
        func handleSubmit() async {
            let db = Firestore.firestore()
            
            //STRIP WHITE SPACES!!!!!!!!!!!!!!
            
            //Upload Photo(GET RID OF ! and handle nil case
            if let image = photoItem {
                let imageUrl = try? await ImageUploader.uploadImage(image: photoImage!)
                formData.image_url = imageUrl!
            } else {
                print("No image selected")
            }
            
            db.collection("users").addDocument(data: ["firstname": formData.first_name, "dob_day": formData.dob_day,"dob_month": formData.dob_month, "dob_year": formData.dob_year,"gender": formData.gender_identity,"image_url" : formData.image_url, "about": formData.about,"likes": [],"matches": [], "uid": userID]) { (error) in
                if let error = error {
                    print("Error saving data. Try again.")
                }
            }
            
            
            
            
            userInfoBool = true
            
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
        var image_url: String = ""
        var about: String = ""
        var likes: [String] = []
        var matches: [String] = []
    }
    

