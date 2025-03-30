//
//  ProfileDetailPage.swift
//  Swappi
//
//  Created by Nysa Jain on 29/03/25.
//


import SwiftUI
import Firebase
import FirebaseAuth

struct ProfileDetailPage: View {
    let name: String
    let vibeEmoji: String
    let skillsKnown: [String]
    let skillsToLearn: [String]
    let moodEmoji: String
    let profileId: String
    @State private var isSaved = false

    var body: some View {
        VStack(spacing: 20) {
            Text(vibeEmoji)
                .font(.system(size: 60))
                .padding(.top, 40)

            Text(name)
                .font(.title)
                .fontWeight(.bold)

            Text("Mood: \(moodEmoji)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                Text("Skills they know:")
                    .font(.headline)
                SkillChips(skills: skillsKnown)

                Text("Skills they want to learn:")
                    .font(.headline)
                SkillChips(skills: skillsToLearn)
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {
                toggleSaveStatus()
            }) {
                HStack {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .foregroundColor(.pink)
                    Text(isSaved ? "Saved" : "Save Profile")
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(14)
                .shadow(radius: 3)
                .padding(.horizontal)
            }

            Spacer(minLength: 50)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
        .onAppear {
            checkIfSaved()
        }
    }

    func toggleSaveStatus() {
        guard let currentUser = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)

        if isSaved {
            userRef.updateData([
                "savedProfiles": FieldValue.arrayRemove([profileId])
            ])
        } else {
            userRef.updateData([
                "savedProfiles": FieldValue.arrayUnion([profileId])
            ])
        }

        isSaved.toggle()
    }

    func checkIfSaved() {
        guard let currentUser = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)

        userRef.getDocument { doc, error in
            if let data = doc?.data(),
               let saved = data["savedProfiles"] as? [String] {
                self.isSaved = saved.contains(profileId)
            }
        }
    }
}

struct SkillChips: View {
    let skills: [String]

    var body: some View {
        WrapHStack(spacing: 8) {
            ForEach(skills, id: \.self) { skill in
                Text(skill)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 1)
            }
        }
    }
}

struct WrapHStack<Content: View>: View {
    let spacing: CGFloat
    let content: () -> Content

    init(spacing: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        LazyVStack(alignment: .leading) {
            content()
        }
    }
}

#Preview {
    ProfileDetailPage(name: "Zoya",
        vibeEmoji: "🎨",
        skillsKnown: ["Painting", "Sketching"],
        skillsToLearn: ["UI Design"],
        moodEmoji: "🌞",
        profileId: "user_zoya_id"
        )
}
