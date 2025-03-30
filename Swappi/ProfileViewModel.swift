//
//  ProfileViewModel.swift
//  Swappi
//
//  Created by Vaishnavi Mahajan on 3/29/25.
//


import Foundation
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
}


