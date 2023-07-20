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
    @SceneStorage("HungryMode") var HungryMode: Bool = false
    
    @State private var activeTab: Tab = .profile
    
    enum Tab {
        case profile
        case swipe
        case matches
        case search
    }
    
    init() {
        _activeTab = State(initialValue: .swipe)
    }
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                if userID == "" {
                    AuthView()
                } else if userInfoBool == false {
                    UserInfo()
                } else {
                    switch activeTab {
                    case .swipe:
                    if HungryMode {
                        HungrySection()
                            .onChange(of: HungryMode) { newValue in
                                // Perform any necessary actions when `HungryMode` changes
                            }
                    } else {
                        CardsSection()
                            .onChange(of: HungryMode) { newValue in
                                // Perform any necessary actions when `HungryMode` changes
                            }
                    }
                    case .profile:
                        ProfileView()
                    case .matches:
                        MatchesView()
                    case .search:
                        SearchBarView()
                    }
                }
            }
            
            VStack {
                Spacer()
                
                NavigationSection(activeTab: $activeTab)
                
                Spacer(minLength: 0) // Add Spacer to push views to the top
            }
            
            VStack {
                Spacer()
                
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

