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
//    let imagePicker = UIImagePickerController()
    let imagePicker = ImagePickerService()
    let slideVc = AvatarImageBottomSheet()
    var viewModel: SettingsViewModel!

// MARK: - ViewController methods
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        viewModel = SettingsViewModel()
        viewModel.bindError = handleError
        nameTextLabel.text = viewModel.userName
        numberTextLabel.text = viewModel.phoneNumber
        if let avatarImageUrl = AuthService.avatarUrl {
            self.avatarImage.loadThumbnail(urlSting: avatarImageUrl)
        } else {
            self.avatarImage.image = K.Images.profilePlaceholder
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.style(with: K.TextStyles.captionBlack60)
        numberLabel.style(with: K.TextStyles.captionBlack60)
        nameTextLabel.style(with: K.TextStyles.bodyBlack)
        numberTextLabel.style(with: K.TextStyles.bodyBlack)

        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .black

        // Do any additional setup after loading the view.
    }

// MARK: - Actions
    @IBAction func logoutButtonPressed(_ sender: Any) {
        viewModel.logout {
            viewModel.setRootViewController()
        }
    }

    @IBAction func uploadImageButtonPressed(_ sender: Any) {
        slideVc.delegate = self
        slideVc.modalPresentationStyle = .custom
        slideVc.transitioningDelegate = self
        self.present(slideVc, animated: true, completion: nil)
    }
    // MARK: - Custom Methods

    private func handleError(title: String, error: Error) {
        self.removeActivityIndicator()
        self.alert(title: title, message: error.localizedDescription)
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [
            UIImagePickerController.InfoKey: Any
            ]
    ) {

        dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {return}
        DispatchQueue.main.async {
            self.avatarImage.image = image
        }
        self.showActivityIndicator()
        viewModel.uploadImage(image: image) {
            self.removeActivityIndicator()
            DispatchQueue.main.async {
                self.avatarImage.image = image
            }
        }
    }
}

extension SettingsViewController: AvatarImageBottomSheetDelegate {
    func removePhotoPressed() {
        slideVc.dismiss(animated: true, completion: nil)
        self.showActivityIndicator()
        viewModel.removeImage {
            self.removeActivityIndicator()
            self.viewWillAppear(false)
        }
    }

    func takePhotoPressed() {
        slideVc.dismiss(animated: true, completion: nil)
        imagePicker.selectImage(self, sourceType: .camera)
    }

    func uploadPhotoPressed() {
        slideVc.dismiss(animated: true, completion: nil)
        let imagePicker = ImagePickerService()
        imagePicker.selectImage(self)
    }
}

extension SettingsViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
