//
//  FileUploadManager.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/24/21.
//

import Foundation
import UIKit
import FirebaseStorage

class FileUploadManager: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {

    private override init() {}

    static let shared = FileUploadManager()

    enum FileUploadType {
        case personalCard
        case networkCard
    }

    private var uploadType: FileUploadType?
    private var urlString: String?
    private var documentId: String?
    private var urlSessionIdentifier = "\(Bundle.main.bundleIdentifier!).photoupload"

    var urlSession: URLSession {
    let configuration = URLSessionConfiguration.background(withIdentifier: urlSessionIdentifier)
        configuration.sessionSendsLaunchEvents = false
        configuration.sharedContainerIdentifier = "groups.photoupload"
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }

    var uploadComplete: (() -> Void)?

    func startUpload(fileUrl: URL, contentType: String, documentId: String, imageType: FileUploadType) {
        if let token = AuthService.idToken {
            self.uploadType = imageType
            self.documentId = documentId
            self.urlString = """
                https://firebasestorage.googleapis.com\
                /v0/b/my-card-a7ec2.appspot.com/o?name=images\
                /profiles/\(documentId).jpg
                """
            let uploadUrl = URL(
                string: urlString!)!
            var urlRequest = URLRequest(url: uploadUrl)
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            urlRequest.httpMethod = "POST"
            DispatchQueue.global(qos: .default).async {[self] in
                let uploadTask = urlSession.uploadTask(with: urlRequest, fromFile: fileUrl)
                uploadTask.resume()
            }
        }
    }

    private func updateDocument(_ storageName: String?) {
        guard let name = storageName else {return}
        let storageReference = Storage.storage().reference()
        let imageRef = storageReference.child(name)
        imageRef.downloadURL {[self] (url, _) in
            if let url = url {
                if uploadType == .personalCard {
                    FirestoreService.shared.editPersonalCard(
                        id: documentId!,
                        field: "profilePicUrl",
                        value: url.absoluteString)
                } else if uploadType == .networkCard {
                    FirestoreService.shared.editContactCard(
                        id: documentId!,
                        field: "profilePicUrl",
                        value: url.absoluteString)
                }
            }
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print(error)
        } else {
            let response = (task.response as? HTTPURLResponse)?.allHeaderFields.map({ (_, value) in
                return value
            })

            print(response!)
            session.finishTasksAndInvalidate()
//            session.finishTasksAndInvalidate()
        }
    }

    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.bgSessionCompletionHandler
                else {
                    return
            }
            appDelegate.bgSessionCompletionHandler = nil
            completionHandler()
        }
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didSendBodyData bytesSent: Int64,
                    totalBytesSent: Int64,
                    totalBytesExpectedToSend: Int64) {
        let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        print(progress)
    }

    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        print("waiting for internet")
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let decoder = JSONDecoder()
        let data = try? decoder.decode(FirestoreStorageResponse.self, from: data)
//        let data = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!

//        print(data?.name)
        updateDocument(data?.name)

//        try? FileManager.default.removeItem(at: location)

    }

    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: (URLSession.ResponseDisposition) -> Void) {
        // We've got the response headers from the server.
        print("didReceive response")
//        self.response = response
        completionHandler(URLSession.ResponseDisposition.allow)
    }
}

struct FirestoreStorageResponse: Decodable {
    var name: String
}
