//
//  AlertView.swift
//  TinderClone4
//
//  Created by Arjun Govind on 7/17/23.
//

import SwiftUI

struct AlertView: View {
    let message: String
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text(message)
                .font(.headline)
                .padding()
                .background(Color.yellow)
                .cornerRadius(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.5))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isPresented = false
            }
        }
    }
}
