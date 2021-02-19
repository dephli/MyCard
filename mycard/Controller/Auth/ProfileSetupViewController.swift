//
//  ProfileSetupViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/15/21.
//

import UIKit

class ProfileSetupViewController: UIViewController {

//    Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    
    
//    Properties
    var profilePicUrl: String?
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.style(with: K.TextStyles.heading1)
        fullNameTextField.becomeFirstResponder()
        fullNameTextField.setTextStyle(with: K.TextStyles.bodyBlack40)

    }
    
//    UIAction
    @IBAction func letsGoButtonPressed(_ sender: Any) {
        self.showActivityIndicator()
        let user = User(name: fullNameTextField.text, avatarImageUrl: profilePicUrl)
        UserAuthManager.auth.updateUser(with: user) { (error) in
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
    
}

//methods
extension ProfileSetupViewController {
    fileprivate func setRootViewController() {
        let storyboard = UIStoryboard(name: "Cards", bundle: nil)
        let tabController = storyboard.instantiateViewController(identifier: K.ViewIdentifiers.cardsTabBarController) as TabBarController
        UIApplication.shared.windows.first?.rootViewController = tabController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

extension ProfileSetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {return}
        
        DispatchQueue.main.async {
            self.avatarImageView.image = image
        }
        
        DataStorageService().uploadImage(image: image) { (url, error) in
            if let error = error {
                self.avatarImageView.image = UIImage()
                self.alert(title: "Image upload failed", message: error.localizedDescription)
            } else {
                self.profilePicUrl = url
            }
        }
    }
}
