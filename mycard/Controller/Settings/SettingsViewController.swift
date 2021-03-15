//
//  SettingsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/18/21.
//

import UIKit

class SettingsViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var numberTextLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!

// MARK: - Properties
    var profilePicUrl: String?
    let imagePicker = UIImagePickerController()

// MARK: - ViewController methods
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        nameTextLabel.text = AuthService.username
        numberTextLabel.text = AuthService.phoneNumber
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.style(with: K.TextStyles.captionBlack60)
        numberLabel.style(with: K.TextStyles.captionBlack60)
        nameTextLabel.style(with: K.TextStyles.bodyBlack)
        numberTextLabel.style(with: K.TextStyles.bodyBlack)

        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .black

        if let avatarImageUrl = AuthService.avatarUrl {
            self.avatarImage.loadThumbnail(urlSting: avatarImageUrl)
        }

        // Do any additional setup after loading the view.
    }

// MARK: - Actions
    @IBAction func logoutButtonPressed(_ sender: Any) {
        UserManager.auth.logout { (error) in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
            } else {
                self.setRootViewController()
                self.navigationController?.popToRootViewController(animated: true)
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
    // MARK: - Custom Methods
    private func setRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            guard let navController = storyboard
                    .instantiateViewController(
                        identifier: K.ViewIdentifiers.startScreenViewController
                    ) as? StartScreenViewController else {
                return
            }
            UIApplication.shared.windows.first?.rootViewController = navController
        } else {
            // Fallback on earlier versions

            guard let navController = storyboard
                    .instantiateViewController(
                        withIdentifier: K.ViewIdentifiers.startScreenViewController
                    ) as? StartScreenViewController else {
                return
            }
            UIApplication.shared.windows.first?.rootViewController = navController
        }

        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [
                                UIImagePickerController.InfoKey: Any
                                ]) {

        dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {return}

        DispatchQueue.main.async {
            self.avatarImage.image = image
        }
        self.showActivityIndicator()

        DataStorageService.uploadImage(image: image, type: .profile) { (url, error) in
            if let error = error {
                self.removeActivityIndicator()
                self.avatarImage.image = K.Images.profilePlaceholder
                self.alert(title: "Image upload failed", message: error.localizedDescription)
            } else {
                let user = User(avatarImageUrl: url)
                UserManager.auth.updateUser(with: user) { (error) in
                    self.removeActivityIndicator()
                    if let error = error {
                        self.alert(title: "Image upload failed", message: error.localizedDescription)
                    }
                }
            }
        }
    }
}
