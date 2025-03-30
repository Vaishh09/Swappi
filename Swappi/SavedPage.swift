//
//  SavedPage.swift
//  Swappi
//
//  Created by Asmi Kachare on 3/29/25.
//

import SwiftUI

struct SavedPage: View {
let savedProfiles: [SavedProfile] = [
    SavedProfile(name: "Zoya", emoji: "🎨", skills: ["Painting", "Sketching"]),
    SavedProfile(name: "Aarav", emoji: "🎸", skills: ["Guitar", "Music Theory"]),
    SavedProfile(name: "Rhea", emoji: "💻", skills: ["Web Dev", "UI/UX"]),
    SavedProfile(name: "Ishaan", emoji: "🧘‍♂️", skills: ["Meditation", "Breathwork"]),
    SavedProfile(name: "Tara", emoji: "🧁", skills: ["Baking", "Cake Design"])
]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text("Saved")
                        .font(.system(size: 28, weight: .bold))
                        .padding(20)
                    Spacer()
                }

                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(savedProfiles) { profile in
                            NavigationLink(
                                destination: ProfileDetailPage(
                                    name: profile.name,
                                    vibeEmoji: profile.emoji,
                                    skillsKnown: profile.skills,
                                    skillsToLearn: ["Skill you want to learn"],
                                    moodEmoji: "🙂",
                                    profileId: profile.id.uuidString
                                )
                            ) {
                                HStack(spacing: 16) {
                                    Text(profile.emoji)
                                        .font(.system(size: 40))
                                        .frame(width: 60, height: 60)
                                        .background(Color.white.opacity(0.5))
                                        .clipShape(Circle())

                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(profile.name)
                                            .font(.title3)
                                            .fontWeight(.semibold)

                                        Text(profile.skills.joined(separator: " • "))
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()
                                }
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 2)
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
        }
    }
}

struct SavedProfile: Identifiable {
let id = UUID()
let name: String
let emoji: String
let skills: [String]
}


#Preview {
    SavedPage()
}
