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
        metadata.contentType = "image/jpeg"
        let storageReference = Storage.storage().reference()

        guard let uid = AuthService.uid else {return}

        let imageRef = storageReference.child("images/profiles/\(uid).jpg")

        imageRef.putData(data, metadata: metadata) { (_, error) in
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

    }

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
