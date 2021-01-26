//
//  StorageService.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 1/25/21.
//

import Foundation
import FirebaseStorage

class StorageService {
    func uploadImage(image: UIImage, onUploadComplete: @escaping(String?, Error?) -> Void) {
        guard let data: Data = image.jpegData(compressionQuality: 1) else {
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        let storageReference = Storage.storage().reference()
        let date = Date().timeIntervalSince1970

        let random = Int.random(in: 10000000..<20000000)
//        to generate unique id for image, use date + a random 8 digit number
        let imageRef = storageReference.child("images/\(date)\(random).jpg")
        imageRef.putData(data, metadata: metadata) { (metadata, error) in
            if let error = error {
                return onUploadComplete(nil, error)
            }
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    return onUploadComplete(nil, error)
                }
                onUploadComplete(url?.absoluteString, nil)
            }
        }
    }
}
