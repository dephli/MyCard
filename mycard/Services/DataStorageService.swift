//
//  StorageService.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 1/25/21.
//

import Foundation
import FirebaseStorage

protocol DataStorageDelegate: AnyObject {
    func uploadImage(image: UIImage, onUploadComplete: @escaping(String?, Error?) -> Void)
}

class DataStorageService {

    enum UploadType {
        case profile
        case companyLogo
        case other
    }

    static func uploadImage(image: UIImage, type: UploadType, onUploadComplete: @escaping(String?, Error?) -> Void) {
        guard let data: Data = image.jpegData(compressionQuality: 1) else {
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        let storageReference = Storage.storage().reference()
        let date = Date().timeIntervalSince1970

        let random = Int.random(in: 10000000..<20000000)
//        to generate unique id for image, use date + a random 8 digit number
        let imageRef: StorageReference?

        switch type {
        case .companyLogo:
            imageRef = storageReference.child("images/companyLogos/\(date)\(random).jpg")
        case .profile:
            imageRef = storageReference.child("images/profiles/\(date)\(random).jpg")
        case .other:
            imageRef = storageReference.child("images/images/\(date)\(random).jpg")
        }

        imageRef?.putData(data, metadata: metadata) { (_, error) in
            if let error = error {
                return onUploadComplete(nil, error)
            }
            imageRef?.downloadURL { (url, error) in
                if let error = error {
                    return onUploadComplete(nil, error)
                }
                onUploadComplete(url?.absoluteString, nil)
            }
        }
    }

    static func deleteImage(url: String, onActionCompleted: @escaping(Error?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: url)

        storageRef.delete { (error) in
            onActionCompleted(error)
        }
    }
}
