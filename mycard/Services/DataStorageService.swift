//
//  StorageService.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 1/25/21.
//

import Foundation
import FirebaseStorage

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

//    enum FileUploadType {
//        case personalCard
//        case networkCard
//    }
//
//    static func startUpload(fileUrl: URL, contentType: String, documentId: String, imageType: FileUploadType) {
//        if let token = AuthService.idToken {
//           self.uploadType = imageType
//            self.documentId = documentId
//            let urlString = "https://firebasestorage.googleapis.com/v0/b/my-card-a7ec2.appspot.com/o?name=images/profile/\(documentId).jpg"
//            let uploadUrl = URL(
//                string: urlString)!
//            var urlRequest = URLRequest(url: uploadUrl)
//            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
//            urlRequest.httpMethod = "POST"
//            let uploadTask = FileUploadManager.shared.urlSession.uploadTask(with: urlRequest, fromFile: fileUrl)
//            uploadTask.resume()
//
//        }
//    }
}
