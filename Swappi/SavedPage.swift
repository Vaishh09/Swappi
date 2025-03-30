import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SavedPage: View {
    @State private var savedProfiles: [UserProfile] = []
    @State private var isLoading = false
    @State private var error: String?
    
    @StateObject private var profileVM = ProfileViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView
                contentView
            }
        }
        .onAppear(perform: loadSavedProfiles)
    }
    
    
    private var headerView: some View {
        HStack {
            Spacer()
            Text("Saved")
                .font(.system(size: 28, weight: .bold))
                .padding(20)
            Spacer()
        }
    }
    
    private var contentView: some View {
        Group {
            if isLoading {
                loadingView
            } else if let error = error {
                errorView(message: error)
            } else if savedProfiles.isEmpty {
                emptyStateView
            } else {
                profileListView
            }
        }
        .background(Color(red: 0.98, green: 0.98, blue: 1.0))
    }
    
    private var loadingView: some View {
        ProgressView()
            .padding(.top, 50)
    }
    
    private func errorView(message: String) -> some View {
        Text("Error: \(message)")
            .foregroundColor(.red)
            .padding()
    }
    
    private var emptyStateView: some View {
        Text("No saved profiles yet")
            .foregroundColor(.gray)
            .padding()
    }
    
    private var profileListView: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(savedProfiles) { profile in
                    NavigationLink(
                        destination: ProfileDetailPage(
                            name: profile.name,
                            vibeEmoji: profile.vibe,
                            skillsKnown: profile.skillsKnown,
                            skillsToLearn: profile.skillsWanted,
                            moodEmoji: profile.mood,
                            profileId: profile.id ?? "",
                            profilePhotos: profile.profilePhotos
                        )
                    ) {
                        ProfileRow(profile: profile)
                    }
                }
            }
            .padding(.bottom, 100)
        }
    }
    
    
    private func loadSavedProfiles() {
        guard let userId = Auth.auth().currentUser?.uid else {
            error = "User not logged in"
            return
        }

        isLoading = true
        error = nil
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { snapshot, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.error = error.localizedDescription
                    return
                }
                
                guard let data = snapshot?.data(),
                      let savedIds = data["savedProfiles"] as? [String] else {
                    self.error = "No saved profiles found"
                    return
                }
                
                self.fetchSavedProfileDetails(profileIds: savedIds)
            }
        }
    }
    
    private func fetchSavedProfileDetails(profileIds: [String]) {
        guard !profileIds.isEmpty else {
            self.savedProfiles = []
            return
        }

        isLoading = true
        
        let db = Firestore.firestore()
        db.collection("users")
            .whereField(FieldPath.documentID(), in: profileIds)
            .getDocuments { snapshot, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.error = error.localizedDescription
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        self.error = "No profiles found"
                        return
                    }
                    
                    self.savedProfiles = documents.compactMap { doc in
                        do {
                            let user = try doc.data(as: UserProfile.self)
                            print("✅ Decoded: \(user.id)")
                            return user
                        } catch {
                            print("❌ Failed to decode doc \(doc.documentID): \(error)")
                            return nil
                        }
                    }
                }
            }
    }
}

#Preview {
    SavedPage()
}
