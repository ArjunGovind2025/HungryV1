//
//  Card.swift
//  TinderClone4
//
//  Created by Arjun Govind on 7/7/23.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseFirestore

//MARK: - DATA
struct Card: Identifiable {
    let id : String
    let name: String
    let imageName: String
    var image: UIImage?
    let age: Int
    let bio: String
    /// Card x position
    var x: CGFloat = 0.0
    /// Card y position
    var y: CGFloat = 0.0
    /// Card rotation angle
    var degree: Double = 0.0
}



