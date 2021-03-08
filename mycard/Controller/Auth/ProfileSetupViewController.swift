//
//  ProfileSetupViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/15/21.
//

import UIKit

class ProfileSetupViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!

// MARK: - Properties
    var profilePicUrl: String?
    let imagePicker = UIImagePickerController()

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.style(with: K.TextStyles.heading1)
        fullNameTextField.becomeFirstResponder()
        fullNameTextField.setTextStyle(with: K.TextStyles.bodyBlack40)
        self.dismissKey()
    }

// MARK: - Actions
    @IBAction func letsGoButtonPressed(_ sender: Any) {
        self.showActivityIndicator()
        let user = User(name: fullNameTextField.text, avatarImageUrl: profilePicUrl)
        UserManager.auth.updateUser(with: user) { (error) in
            self.removeActivityIndicator()
            if let error = error {
                self.alert(title: "Profile Update Failed", message: error.localizedDescription)
            } else {
                self.setRootViewController()
                self.performSegue(withIdentifier: K.Segues.authToCards, sender: self)
            }
        }
    }

    @IBAction func uploadImageButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }

// MARK: - Methods
    private func setRootViewController() {
        let storyboard = UIStoryboard(name: "Cards", bundle: nil)
        let tabController = storyboard.instantiateViewController(
            identifier: K.ViewIdentifiers.cardsTabBarController
        ) as TabBarController
        UIApplication.shared.windows.first?.rootViewController = tabController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

}

// MARK: - ImagePicker Delegate
extension ProfileSetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [
                                UIImagePickerController.InfoKey: Any
                                ]) {

        dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {return}

        DispatchQueue.main.async {
            self.avatarImageView.image = image
        }
        self.showActivityIndicator()

        DataStorageService.uploadImage(image: image, type: .profile) { (url, error) in
            self.removeActivityIndicator()
            if let error = error {
                self.avatarImageView.image = UIImage()
                self.alert(title: "Image upload failed", message: error.localizedDescription)
            } else {
                self.profilePicUrl = url
            }
        }
    }
}
