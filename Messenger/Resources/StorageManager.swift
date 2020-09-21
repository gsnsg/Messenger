//
//  StorageManager.swift
//  Messenger
//
//  Created by Nikhi on 21/09/20.
//  Copyright © 2020 nikhit. All rights reserved.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    

    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    /// Uploads picture to firebase storage and returns completion with URL string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else {
                print("Failed to upload image to firebase storage")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL { (url, error) in
                guard url != nil else {
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                let urlString = url!.absoluteString
                print("Dwonload url returned: \(urlString)")
                completion(.success(urlString))
            }
        }
    }
    
    public enum StorageErrors: Error {
         case failedToUpload
        case failedToGetDownloadURL
    }
}


