import SwiftUI

struct NavigationSect: View {
    @State private var selectedTab: Tab = .profile
    
    enum Tab {
        case profile
        case swipe
        case matches
        case search
    }
    
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
    
    @ViewBuilder
    func tabButton(title: String, image: String, tab: Tab) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 4) {
                Image(systemName: image)
                    .font(.system(size: 24))
                    .foregroundColor(selectedTab == tab ? .blue : .gray)
                Text(title)
                    .font(.caption)
                    .foregroundColor(selectedTab == tab ? .blue : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}


