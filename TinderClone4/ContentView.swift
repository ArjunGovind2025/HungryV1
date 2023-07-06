//
//  ContentView.swift
//  TinderClone4
//
//  Created by Arjun Govind on 6/30/23.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @AppStorage("uid") var userID: String = ""
    @AppStorage("UIBool") var userInfoBool: Bool = false
    
    @State private var navigateToUserInfo = false
    
    var body: some View {
        
        if userID == "" {
            AuthView()
        } else if userInfoBool == false {
            UserInfo()
            
        } else {
            Text("Logged In! \nYour user id is \(userID)")
            
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
