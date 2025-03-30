//
//  SearchPage.swift
//  Swappi
//
//  Created by Asmi Kachare on 3/29/25.
//

import SwiftUI

struct SearchPage: View {
    @State private var searchText: String = ""
    
    let recentSearches = [
        "UI design", "Meditation", "Introverts", "Photography", "Python", "Study buddy"
    ]
    
    let suggestions = [
        "People who teach UI/UX", "Looking to learn Java",
        "Creative writers", "Baking buddies 🍰",
        "Introverts who vibe 🌙", "Guitar swaps 🎸",
        "Chill coders", "Coffee chat people ☕️",
        "Productivity partners 📚", "Therapy talkers",
        "Design collabs 🎨", "Gamers looking to swap skills 🎮"
    ]
    
    let pastelTints: [Color] = [
        Color(red: 0.94, green: 0.97, blue: 1.0),
        Color(red: 1.0, green: 0.95, blue: 0.95),
        Color(red: 0.95, green: 1.0, blue: 0.95),
        Color(red: 1.0, green: 0.98, blue: 0.9),
        Color(red: 0.96, green: 0.94, blue: 1.0) 
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search skills, vibes, people...", text: $searchText)
                        .foregroundColor(.primary)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.top, 30)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(recentSearches, id: \.self) { term in
                            Text(term)
                                .font(.caption)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                }

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(suggestions.indices, id: \.self) { index in
                            Text(suggestions[index])
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, minHeight: 90)
                                .padding()
                                .background(pastelTints[index % pastelTints.count])
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
            }

        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
    }
}

#Preview {
    SearchPage()
}
