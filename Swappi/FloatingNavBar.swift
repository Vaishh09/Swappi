//
//  FloatingNavBar.swift
//  Swappi
//
//  Created by Vaishnavi Mahajan on 3/29/25.
//


import SwiftUI

struct FloatingNavBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "magnifyingglass")
                .onTapGesture { selectedTab = .search }
            Spacer()
            Image(systemName: "message")
                .onTapGesture { selectedTab = .messages }
            Spacer()
            Image(systemName: "house")
                .onTapGesture { selectedTab = .home }
            Spacer()
            Image(systemName: "bookmark")
                .onTapGesture { selectedTab = .saved }
            Spacer()
            Image(systemName: "gear")
                .onTapGesture { selectedTab = .settings }
            Spacer()
            Image(systemName: "person.crop.circle")
                .onTapGesture { selectedTab = .profile }
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(30)
        .shadow(radius: 5)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}
