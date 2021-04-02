////
////  ImageUploadJob.swift
////  mycard
////
////  Created by Joseph Maclean Arhin on 3/26/21.
////
//
// import Foundation
// import SwiftQueue
// import Firebase
// import OSLog
//
// class ImageUploadJob: Job {
//    static let type = String(describing: ImageUploadJob.self)
//
//    private let url: URL
//    private let imageType: DataStorageService.ImageType
//    private let documentId: String
//
//    required init(imageUrl: URL, documentId: String, type: DataStorageService.ImageType) {
//        self.url = imageUrl
//        self.documentId = documentId
//        self.imageType = type
//    }
//
//    func onRun(callback: JobResult) {
//        DataStorageService.uploadImage(withUrl: url, documentId: documentId, imageType: imageType) { error, _  in
//            if let error = error {
//                os_log("========================================")
//                let customLog = OSLog(subsystem: Bundle.main.bundleIdentifier!,
//                                      category: error.localizedDescription)
//                os_log("An error occurred!", log: customLog, type: .error)
//
//                callback.done(.fail(error))
//            } else {
//                    callback.done(.success)
//            }
//        }
//    }
//
//    func onRetry(error: Error) -> RetryConstraint {
//        if error._code == NSURLErrorNetworkConnectionLost {
//            return RetryConstraint.retry(delay: 60*3)
//        } else {
//            return RetryConstraint.cancel
//        }
//    }
//
//    func onRemove(result: JobCompletion) {
//        switch result {
//        case .success:
//            print("Job success")
//        case .fail:
//            print("Job fail")
//        }
//    }
// }
//
// class UploadJobCreator: JobCreator {
//    func create(type: String, params: [String: Any]?) -> Job {
//        if type == ImageUploadJob.type {
//            if let path = params?["path"] as? URL,
//               let documentId = params?["documentId"] as? String,
//               let imageType = params?["imageType"] as? DataStorageService.ImageType {
//                return ImageUploadJob(imageUrl: path, documentId: documentId, type: imageType)
//            } else {
//                fatalError("file path and image type not specified")
//            }
//        } else {
//            fatalError("No job")
//        }
//    }
// }
