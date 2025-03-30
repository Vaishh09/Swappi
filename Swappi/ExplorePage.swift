import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ExploreView: View {
    @StateObject var profileVM = ProfileViewModel()
    @State var otherUsers: [UserProfile] = []
    @State var currentUser: UserProfile? = nil
    
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("Explore")
                    .font(.system(size: 32, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(otherUsers.enumerated()), id: \.offset) { index, user in
                            NavigationLink(destination: ProfileDetailPage(
                                name: user.name,
                                vibeEmoji: user.vibe,
                                skillsKnown: user.skillsKnown,
                                skillsToLearn: user.skillsWanted,
                                moodEmoji: user.mood,
                                profileId: user.id ?? "",
                                profilePhotos: user.profilePhotos
                            )) {
                                
                                PinterestCard(
                                    user: user,
                                    height: [260, 220, 240, 200, 280][index % 5]
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(16)
                    .padding(.bottom, 80)
                }
            }
            .onAppear(perform: loadUsers)
            .background(Color(UIColor.systemBackground))
        }
    }
    
    private func loadUsers() {
        profileVM.fetchOtherUserProfiles { users in
            guard let currentUID = Auth.auth().currentUser?.uid else { return }
            
            Firestore.firestore().collection("users").document(currentUID).getDocument { snapshot, error in
                guard let data = snapshot?.data() else { return }
                
                let current = UserProfile(
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    skillsKnown: data["skillsKnown"] as? [String] ?? [],
                    skillsWanted: data["skillsWanted"] as? [String] ?? [],
                    vibe: data["vibe"] as? String ?? "",
                    mood: data["mood"] as? String ?? "",
                    note: data["note"] as? String ?? "",
                    profilePhotos: data["profilePhotos"] as? [String] ?? [],
                    introMediaURL: data["introMediaURL"] as? String ?? ""
                )
                
                self.currentUser = current
                
                let scoredUsers = users.map { user in
                    (user, profileVM.basicMatchScore(userA: current, userB: user))
                }.sorted(by: { $0.1 > $1.1 })
                
                self.otherUsers = scoredUsers.map { $0.0 }
            }
        }
    }
}

struct PinterestCard: View {
    let user: UserProfile
    let height: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if let imageURL = user.profilePhotos.first, !imageURL.isEmpty {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: height)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: height)
                            .clipped()
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: height)
                    @unknown default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: height)
                    }
                }
                .cornerRadius(16)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: height)
                    .cornerRadius(16)
            }
            
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(user.mood)
                        .font(.system(size: 16))
                    Text(user.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                }
                
                if !user.skillsKnown.isEmpty {
                    Text(user.skillsKnown.prefix(2).joined(separator: " • "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 6)
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        
        .padding(4)
    }
}

#Preview {
    ExploreView()
}
