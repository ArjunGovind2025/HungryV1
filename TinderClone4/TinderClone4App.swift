//
//  TinderClone4App.swift
//  TinderClone4
//
//  Created by Arjun Govind on 6/30/23.
//


import SwiftUI
import FirebaseCore


@main
struct SwiftUI_AuthApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
