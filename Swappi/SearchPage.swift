import SwiftUI
import FirebaseFirestore

struct SearchPage: View {
    @State private var searchText: String = ""
    @State private var searchResults: [UserProfile] = []
    @State private var isSearching = false
    
    let recentSearches = [
        "UI design", "Meditation", "Introverts", "Photography", "Python", "Study buddy"
    ]
    
    let pastelTints: [Color] = [
        Color(red: 0.94, green: 0.97, blue: 1.0),
        Color(red: 1.0, green: 0.95, blue: 0.95),
        Color(red: 0.95, green: 1.0, blue: 0.95),
        Color(red: 1.0, green: 0.98, blue: 0.9),
        Color(red: 0.96, green: 0.94, blue: 1.0)
    ]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search skills, vibes, people...", text: $searchText)
                            .onChange(of: searchText) { _ in
                                performSearch()
                            }
                            .foregroundColor(.primary)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                searchResults = []
                            }) {
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
                                    .onTapGesture {
                                        searchText = term
                                        performSearch()
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                    }
                    
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            
                            
                            if isSearching {
                                ProgressView()
                                    .padding()
                            
                                
                            
                            } else {
                                ForEach(searchResults.indices, id: \.self) { index in
                                    let user = searchResults[index]
                                    
                                    NavigationLink(destination: ProfileDetailPage(
                                        name: user.name,
                                        vibeEmoji: user.vibe ?? "",
                                        skillsKnown: user.skillsKnown,
                                        skillsToLearn: user.skillsWanted ?? [],
                                        moodEmoji: user.mood ?? "😊",
                                        profileId: user.id ?? "",
                                        profilePhotos: user.profilePhotos ?? []
                                    )) {
                                        VStack {
                                            Text(user.name)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            
                                            Text(user.skillsKnown.joined(separator: " • "))
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(pastelTints[index % pastelTints.count])
                                        .cornerRadius(16)
                                        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
            .background(Color(red: 0.98, green: 0.98, blue: 1.0).ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    func performSearch() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            searchResults = []
            return
        }
        
        let lowerTrim = trimmed.lowercased()
        isSearching = true
        let db = Firestore.firestore()
        
        
        db.collection("users")
            .getDocuments { snapshot, error in
                isSearching = false
                if let error = error {
                    print("Search error:", error)
                    return
                }
                
                if let documents = snapshot?.documents {
                    searchResults = documents.compactMap { doc -> UserProfile? in
                        guard var profile = try? doc.data(as: UserProfile.self) else { return nil }
                        
                        
                        let hasMatchingSkill = profile.skillsKnown.contains { skill in
                            skill.lowercased().contains(lowerTrim)
                        }
                        
                        
                        if profile.id == nil {
                            profile.id = doc.documentID
                        }
                        
                        return hasMatchingSkill ? profile : nil
                    }
                }
            }
    }
}

#Preview{
    SearchPage()
}
