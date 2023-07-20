//
//  TinderClone4App.swift
//  TinderClone4
//
//  Created by Arjun Govind on 6/30/23.
//


import SwiftUI
import Firebase
import FirebaseCore



@main
struct SwiftUI_AuthApp: App {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Database.database().reference()
    }
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

