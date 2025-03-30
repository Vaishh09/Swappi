import SwiftUI

struct FloatingNavBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack {
            Spacer()
            navIcon("magnifyingglass", tab: .search)
            Spacer()
            navIcon("message", tab: .messages)
            Spacer()
            navIcon("house", tab: .home)
            Spacer()
            navIcon("bookmark", tab: .saved)
            Spacer()
            navIcon("gear", tab: .settings)
            Spacer()
            navIcon("person.crop.circle", tab: .profile)
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }

    
    private func navIcon(_ systemName: String, tab: Tab) -> some View {
        
        let selectedColor = Color(red: 0.65, green: 0.75, blue: 1.0)
        let unselectedColor = Color(red: 0.7, green: 0.7, blue: 0.7).opacity(0.6)

        return Image(systemName: systemName)
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(selectedTab == tab ? selectedColor : unselectedColor)
            .onTapGesture {
                selectedTab = tab
            }
    }
}
