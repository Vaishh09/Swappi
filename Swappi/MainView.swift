//
//  MainView.swift
//  Swappi
//
//  Created by Nysa Jain on 29/03/25.
//

import SwiftUI

enum Tab {
    case search
    case messages
    case home
    case saved
    case settings
    case profile
}

struct MainView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .search:
                    SearchPage()
                case .messages:
                    MessagesPage()
                case .home:
                    ExploreView()
                case .saved:
                    SavedPage()
                case .settings:
                    SettingsPage()
                case .profile:
                    AboutYouPage()
                }
            }

            FloatingNavBar(selectedTab: $selectedTab)
        }
    }
}
