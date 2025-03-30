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
    let profilePhotos: [String]

    
    @State private var isSaved = false
    @State private var navigateToChat = false

    
    private var heroImageURL: String {
        profilePhotos.first ?? ""
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroSection
                VStack(alignment: .leading, spacing: 16) {
                    vibeSection
                    Divider()
                    skillSection
                    buttonSection
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 80)
            }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
        .onAppear { checkIfSaved() }
    }

    
    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            if !heroImageURL.isEmpty, let url = URL(string: heroImageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 300)
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                    @unknown default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                    }
                }
            } else {
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
            }

            Text(name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(radius: 2)
                .padding(.leading, 16)
                .padding(.bottom, 16)
        }
    }

    
    private var vibeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("My current vibe: \(vibeEmoji)")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Mood: \(moodEmoji)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }

    
    private var skillSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Skills they know:")
                .font(.headline)
            SkillChips(skills: skillsKnown)

            Text("Skills they want to learn:")
                .font(.headline)
            SkillChips(skills: skillsToLearn)
        }
    }

    
    private var buttonSection: some View {
        VStack(spacing: 12) {
            Button(action: toggleSaveStatus) {
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
            }

            NavigationLink(destination: ChatPage(userName: name, moodEmoji: moodEmoji), isActive: $navigateToChat) {
                EmptyView()
            }
            Button(action: {
                navigateToChat = true
            }) {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("Message")
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(14)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 16)
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
