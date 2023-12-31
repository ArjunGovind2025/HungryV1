//
//  NavigationSection.swift
//  TinderClone4
//
//  Created by Arjun Govind on 7/9/23.
//

import SwiftUI

struct NavigationSection: View {
    @Binding var activeTab: ContentView.Tab
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            HStack(spacing: 0) {
                tabButton(title: "Profile", image: "person.fill", tab: .profile)
                tabButton(title: "Swipe", image: "heart.fill", tab: .swipe)
                tabButton(title: "Matches", image: "message.fill", tab: .matches)
                tabButton(title: "Search", image: "magnifyingglass", tab: .search)
            }
            .frame(height: 50)
            .background(Color.white)
        }
    }
    
    func tabButton(title: String, image: String, tab: ContentView.Tab) -> some View {
        Button(action: {
            activeTab = tab
        }) {
            VStack(spacing: 4) {
                Image(systemName: image)
                    .font(.system(size: 24))
                    .foregroundColor(activeTab == tab ? .blue : .gray)
                Text(title)
                    .font(.caption)
                    .foregroundColor(activeTab == tab ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

/**struct NavigationSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSection()
    }
}*/


