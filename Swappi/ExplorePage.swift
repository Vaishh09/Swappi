//
//  ExplorePage.swift
//  Swappi
//
//  Created by Asmi Kachare on 3/29/25.
//

import SwiftUI

struct ExploreView: View {
    let pastelColors: [Color] = [
        Color(red: 0.95, green: 0.88, blue: 1.0),
        Color(red: 0.87, green: 0.94, blue: 1.0),
        Color(red: 0.94, green: 1.0, blue: 0.87),
        Color(red: 1.0, green: 0.94, blue: 0.87),
        Color(red: 1.0, green: 0.88, blue: 0.95)
    ]

    let items = Array(1...20)

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Text("Explore")
                    .font(.system(size: 28, weight: .bold))
                    .padding(10)

                ScrollView {
                    HStack(alignment: .top, spacing: 12) {
                        VStack(spacing: 12) {
                            ForEach(items.enumerated().filter { $0.offset % 2 == 0 }, id: \.element) { index, item in
                                ExploreCard(
                                    index: item,
                                    color: pastelColors[item % pastelColors.count],
                                    username: "Zoya",
                                    vibeEmoji: "🎨",
                                    skills: ["Painting", "UI Design"]
                                )
                            }
                        }

                        VStack(spacing: 12) {
                            ForEach(items.enumerated().filter { $0.offset % 2 == 1 }, id: \.element) { index, item in
                                ExploreCard(
                                    index: item,
                                    color: pastelColors[item % pastelColors.count],
                                    username: "Zoya",
                                    vibeEmoji: "🎨",
                                    skills: ["Painting", "UI Design"]
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
            }

            FloatingNavBar()
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
    }
}

struct ExploreCard: View {
    let index: Int
    let color: Color
    let username: String
    let vibeEmoji: String
    let skills: [String]

    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(color)
                .frame(height: CGFloat.random(in: 200...300))
                .cornerRadius(16)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(vibeEmoji)
                        .font(.system(size: 18))

                    Text(username)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .shadow(radius: 1)
                }

                Text(skills.joined(separator: " • "))
                    .font(.caption2)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .shadow(radius: 1)
            }
            .padding(10)
            .background(Color.black.opacity(0.25))
            .cornerRadius(12)
            .padding(10)
        }
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 2)
    }
}

struct FloatingNavBar: View {
    var body: some View {
        HStack {
            Spacer()
            NavBarIcon(icon: "magnifyingglass")
            Spacer()
            NavBarIcon(icon: "message")
            Spacer()
            NavBarIcon(icon: "house")
            Spacer()
            NavBarIcon(icon: "bookmark")
            Spacer()
            NavBarIcon(icon: "gear")
            Spacer()
            NavBarIcon(icon: "person.crop.circle")
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

struct NavBarIcon: View {
    let icon: String
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(.primary)
    }
}

#Preview {
    ExploreView()
}
