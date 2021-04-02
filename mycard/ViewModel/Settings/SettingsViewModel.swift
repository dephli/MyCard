//
//  SettingsViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 4/1/21.
//
import UIKit

class SettingsViewModel: BaseViewModel {
    var userName: String? {
        AuthService.username
    }

    var phoneNumber: String? {
        AuthService.phoneNumber
    }

    var avatarImageUrl: String? {
        AuthService.avatarUrl
    }

    func logout(completionHandler: () -> Void) {
        UserManager.auth.logout { (error) in
            if let error = error {
                bindError("Error Logging Out", error)
            } else {
                completionHandler()
            }
        }
    }

    func uploadImage(image: UIImage, completionHandler: @escaping() -> Void) {
        DataStorageService.uploadImage(image: image, type: .profile) {[self] (url, error) in
            if error != nil {
                let uploadError = CustomError(
                    str: "Could not use the selected image as an avatar image. Please make sure you select a jpg or a png image")
                    as Error
                bindError("Image upload failed", uploadError)
            } else {
                let user = User(avatarImageUrl: url)
                UserManager.auth.updateUser(with: user) { (error) in
                    if error != nil {
                        let uploadError = CustomError(
                            str: "Image upload failed. Please check if you have an internet connection")
                            as Error
                        bindError("Image upload failed", uploadError)
                    } else {
                        completionHandler()
                    }
                }
            }
        }
    }

    func removeImage(completionHandler: @escaping() -> Void) {
        guard let url = avatarImageUrl else {return}
        DataStorageService.deleteImage(url: url) {error in
            if error != nil {
                let removalError = CustomError(str: "") as Error
                self.bindError("Image Removal Failed", removalError)
            } else {
                AuthService().removeAvatarUrl { error in
                    if let error = error {
                        self.bindError("Image Removal Failed", error)
                    } else {
                        completionHandler()
                    }
                }
            }
        }
    }

    func setRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navController = storyboard
                .instantiateViewController(
                    identifier: K.ViewIdentifiers.startScreenViewController
                ) as? StartScreenViewController else {
            return
        }
        UIApplication.shared.windows.first?.rootViewController = navController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
