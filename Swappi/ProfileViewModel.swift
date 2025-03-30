//
//  ProfileViewModel.swift
//  Swappi
//
//  Created by Vaishnavi Mahajan on 3/29/25.
//

import FirebaseFirestore
import FirebaseAuth

struct UserProfile {
    let name: String
    let email: String
    let vibe: String
    let mood: String
    let skillsKnown: [String]
    let skillsWanted: [String]
    let profilePhotos: [String]
    let introMediaURL: String
    let note: String?
    let uid: String
}

class ProfileViewModel: ObservableObject {
    func saveUserProfile(profile: UserProfile, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in."])))
            return
        }

        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "name": profile.name,
            "email": profile.email,
            "vibe": profile.vibe,
            "mood": profile.mood,
            "skillsKnown": profile.skillsKnown,
            "skillsWanted": profile.skillsWanted,
            "profilePhotos": profile.profilePhotos,
            "introMediaURL": profile.introMediaURL,
            "note": profile.note ?? ""
        ]

        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func fetchOtherUserProfiles(completion: @escaping ([UserProfile]) -> Void) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else {
                print("❌ Failed to fetch user documents.")
                return
            }

            print("📦 Total user docs: \(docs.count)")
            
            let users = docs.compactMap { doc -> UserProfile? in
                let uid = doc.documentID
                //if uid == currentUID { return nil }

                print("👀 Checking user: \(uid)")

                let data = doc.data()

                guard
                    let name = data["name"] as? String,
                    let email = data["email"] as? String,
                    let vibe = data["vibe"] as? String,
                    let mood = data["mood"] as? String,
                    let skillsKnown = data["skillsKnown"] as? [String],
                    let skillsWanted = data["skillsWanted"] as? [String],
                    let profilePhotos = data["profilePhotos"] as? [String],
                    let introMediaURL = data["introMediaURL"] as? String
                else {
                    print("⚠️ Skipping user \(uid) — missing fields")
                    return nil
                }

                return UserProfile(
                    name: name,
                    email: email,
                    vibe: vibe,
                    mood: mood,
                    skillsKnown: skillsKnown,
                    skillsWanted: skillsWanted,
                    profilePhotos: profilePhotos,
                    introMediaURL: introMediaURL,
                    note: data["note"] as? String,
                    uid: uid
                )
            }

            print("✅ Loaded \(users.count) user(s) after filtering")
            completion(users)
        }
    }

    func basicMatchScore(userA: UserProfile, userB: UserProfile) -> Int {
        let skillMatch = Set(userA.skillsWanted).intersection(userB.skillsKnown).count * 20
        let moodMatch = userA.mood == userB.mood ? 10 : 0
        let vibeMatch = userA.vibe.lowercased() == userB.vibe.lowercased() ? 10 : 0
        return min(skillMatch + moodMatch + vibeMatch, 100)
    }

    func storeMatch(currentUID: String, matchUID: String, score: Int) {
        let db = Firestore.firestore()
        db.collection("matches").document(currentUID).collection("matched_with").document(matchUID).setData([
            "score": score,
            "timestamp": Timestamp()
        ]) { error in
            if let error = error {
                print("Error storing match: \(error.localizedDescription)")
            } else {
                print("Match stored successfully.")
            }
        }
    }
}
