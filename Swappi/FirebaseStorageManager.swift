//
//  FirebaseStorageManager.swift
//  Swappi
//
//  Created by Vaishnavi Mahajan on 3/29/25.
//

import FirebaseStorage
import UIKit

class FirebaseStorageManager {
    static func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = Storage.storage().reference()
        let imageData = image.jpegData(compressionQuality: 0.8)

        guard let data = imageData else {
            completion(.failure(NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid image"])))
            return
        }

        let fileName = UUID().uuidString + ".jpg"
        let imageRef = storageRef.child("profile_images/\(fileName)")

        imageRef.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                imageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let downloadURL = url {
                        completion(.success(downloadURL.absoluteString))
                    }
                }
            }
        }
    }
}

extension FirebaseStorageManager {
    static func uploadMultipleImages(_ images: [UIImage], completion: @escaping ([String]) -> Void) {
        var uploadedURLs: [String] = []
        let dispatchGroup = DispatchGroup()

        for image in images {
            dispatchGroup.enter()
            uploadImage(image) { result in
                switch result {
                case .success(let url):
                    uploadedURLs.append(url)
                case .failure(let error):
                    print("Upload failed: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(uploadedURLs)
        }
    }
}



