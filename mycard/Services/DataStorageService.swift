//
//  StorageService.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 1/25/21.
//

import Foundation
import FirebaseStorage
import SwiftQueue

class DataStorageService {

    enum UploadType {
        case profile
        case network
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
//        to generate unique id for image, use date + a random 8 digit number
        let imageRef: StorageReference?

        let date = Date().timeIntervalSince1970

//        to generate unique id for image, use date + a random 8 digit number
        guard let uid = AuthService.uid else {return}
        switch type {
        case .companyLogo:
            imageRef = storageReference.child("images/companyLogos/\(uid)\(date).jpg")
        case .profile:

            imageRef = storageReference.child("images/profiles/\(uid).jpg")
        case .network:
            imageRef = storageReference.child("images/profiles/\(uid)\(date).jpg")
        case .other:
            imageRef = storageReference.child("images/\(uid)\(date).jpg")
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

    static func uploadImage(image: UIImage,
                            documentId: String,
                            imageType: FileUploadManager.FileUploadType,
                            completionHandler: @escaping(Error?) -> Void) {

        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
        let imagePath = documentsPath?.appendingPathComponent("\(documentId).jpg")
        do {
            try image.jpegData(compressionQuality: 1)?.write(to: imagePath!)
        } catch {
            let error = CustomError(str: "Failed to load upload image") as Error
            completionHandler(error)
        }

        startUpload(
            fileUrl: imagePath!,
            contentType: "application/octet-stream",
            documentId: documentId,
            imageType: imageType
        )

// MARK: - Using Swiftqueue
//        JobBuilder(type: ImageUploadJob.type)
//            // One job per upload
//            .singleInstance(forId: String(documentId))
//            // Name the queue so SwiftQueue create a background task
//            .parallel(queueName: "\(Bundle.main.bundleIdentifier)/photoupload")
//            .with(params: [
//                "path": imagePath!,
//                "documentId": documentId,
//                "imageType": imageType
//            ]).retry(limit: .limited(5))
//            .persist()
//            .schedule(manager: uploadManager)
    }

//    static func uploadImage(withUrl localFile: URL, documentId: String, imageType: ImageType, completionHandler: @escaping (Error?, String?) -> Void) {
//        let storage = Storage.storage()
//        let storageRef = storage.reference()
//        let ref = storageRef.child("images/profile/\(documentId).jpg")
//
//        ref.putFile(from: localFile, metadata: nil) { _, error in
//
//            if let error = error {
//                completionHandler(error, nil)
//            } else {
//                ref.downloadURL { (url, error) in
//                    if let error = error {
//                        completionHandler(error, nil)
//                    } else {
//                        if imageType == .personalCard {
//                            FirestoreService.shared.editPersonalCard(
//                                id: documentId,
//                                field: "profilePicUrl",
//                                value: url!.absoluteString)
//                        } else if imageType == .networkCard {
//                            FirestoreService.shared.editContactCard(
//                                id: documentId,
//                                field: "profilePicUrl",
//                                value: url!.absoluteString)
//                        }
//                    }
//                }
//            }
//        }
//    }

    static func startUpload(
        fileUrl: URL,
        contentType: String,
        documentId: String,
        imageType: FileUploadManager.FileUploadType
    ) {
            FileUploadManager.shared.startUpload(
                fileUrl: fileUrl,
                contentType: contentType,
                documentId: documentId,
                imageType: imageType
            )
    }

    enum ImageType: String {
        case personalCard
        case networkCard
    }
}
