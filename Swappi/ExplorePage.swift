//
//  ExplorePage.swift
//  Swappi
//
//  Created by Asmi Kachare on 3/29/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ExploreView: View {
    @StateObject var profileVM = ProfileViewModel()
    @State var otherUsers: [UserProfile] = []
    @State var currentUser: UserProfile? = nil

    let pastelColors: [Color] = [
        Color(red: 0.95, green: 0.88, blue: 1.0),
        Color(red: 0.87, green: 0.94, blue: 1.0),
        Color(red: 0.94, green: 1.0, blue: 0.87),
        Color(red: 1.0, green: 0.94, blue: 0.87),
        Color(red: 1.0, green: 0.88, blue: 0.95)
    ]

    var body: some View {
        let pairedUsers = Array(otherUsers.enumerated())
        let leftColumnUsers = pairedUsers.filter { $0.offset % 2 == 0 }
        let rightColumnUsers = pairedUsers.filter { $0.offset % 2 == 1 }

        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    Text("Explore")
                        .font(.system(size: 28, weight: .bold))
                        .padding(10)

                    ScrollView {
                        HStack(alignment: .top, spacing: 12) {
                            VStack(spacing: 12) {
                                Button("➕ Add Dummy User") {
                                    let dummy = UserProfile(
                                        name: "Zoya Debug",
                                        email: "zoya@debug.com",
                                        vibe: "Matcha",
                                        mood: "😊",
                                        skillsKnown: ["Swift", "UI"],
                                        skillsWanted: ["Firebase"],
                                        profilePhotos: [],
                                        introMediaURL: "",
                                        note: "Test User",
                                        uid: UUID().uuidString
                                    )
                                    profileVM.saveUserProfile(profile: dummy) { result in
                                        print("✅ Dummy added: \(result)")
                                    }
                                }
                                
                                ForEach(leftColumnUsers, id: \.offset) { pair in
                                    let index = pair.offset
                                    let user = pair.element
                                    VStack {
                                        NavigationLink(destination:
                                            ProfileDetailPage(
                                                name: user.name,
                                                vibeEmoji: "🌟",
                                                skillsKnown: user.skillsKnown,
                                                skillsToLearn: user.skillsWanted,
                                                moodEmoji: user.mood,
                                                profileId: user.uid
                                            )
                                        ) {
                                            ExploreCard(
                                                index: index,
                                                color: pastelColors[index % pastelColors.count],
                                                username: user.name,
                                                vibeEmoji: "🌟",
                                                skills: user.skillsKnown
                                            )
                                        }

                                        if let currentUser = currentUser {
                                            Button("🤝 Match") {
                                                let score = profileVM.basicMatchScore(userA: currentUser, userB: user)
                                                profileVM.storeMatch(currentUID: currentUser.uid, matchUID: user.uid, score: score)
                                            }
                                            .font(.caption)
                                            .padding(6)
                                            .background(Color.blue.opacity(0.8))
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                            VStack(spacing: 12) {
                                ForEach(rightColumnUsers, id: \.offset) { pair in
                                    let index = pair.offset
                                    let user = pair.element
                                    VStack {
                                        NavigationLink(destination:
                                            ProfileDetailPage(
                                                name: user.name,
                                                vibeEmoji: "🌟",
                                                skillsKnown: user.skillsKnown,
                                                skillsToLearn: user.skillsWanted,
                                                moodEmoji: user.mood,
                                                profileId: user.uid
                                            )
                                        ) {
                                            ExploreCard(
                                                index: index,
                                                color: pastelColors[index % pastelColors.count],
                                                username: user.name,
                                                vibeEmoji: "🌟",
                                                skills: user.skillsKnown
                                            )
                                        }

                                        if let currentUser = currentUser {
                                            Button("🤝 Match") {
                                                let score = profileVM.basicMatchScore(userA: currentUser, userB: user)
                                                profileVM.storeMatch(currentUID: currentUser.uid, matchUID: user.uid, score: score)
                                            }
                                            .font(.caption)
                                            .padding(6)
                                            .background(Color.blue.opacity(0.8))
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
            .onAppear {
                profileVM.fetchOtherUserProfiles { users in
                    guard let currentUID = Auth.auth().currentUser?.uid else { return }

                    Firestore.firestore().collection("users").document(currentUID).getDocument { snapshot, error in
                        guard let data = snapshot?.data() else { return }

                        let current = UserProfile(
                            name: data["name"] as? String ?? "",
                            email: data["email"] as? String ?? "",
                            vibe: data["vibe"] as? String ?? "",
                            mood: data["mood"] as? String ?? "",
                            skillsKnown: data["skillsKnown"] as? [String] ?? [],
                            skillsWanted: data["skillsWanted"] as? [String] ?? [],
                            profilePhotos: data["profilePhotos"] as? [String] ?? [],
                            introMediaURL: data["introMediaURL"] as? String ?? "",
                            note: data["note"] as? String ?? "",
                            uid: currentUID
                        )

                        self.currentUser = current

                        let scoredUsers = users.map { user in
                            return (user, profileVM.basicMatchScore(userA: current, userB: user))
                        }.sorted(by: { $0.1 > $1.1 })

                        self.otherUsers = scoredUsers.map { $0.0 }
                    }
                }
            }
            .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
        }
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

#Preview {
    ExploreView()
}
