//
//  WorkInfoViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/20/20.
//

import UIKit

class WorkInfoViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var navigationBar: CustomNavigationBar!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var workInfoSectionLabel: UILabel!
    @IBOutlet weak var workLocationLabel: UILabel!
    @IBOutlet weak var continueButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var workLocationTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

// MARK: - Variables
    var companyImage: UIImage?
    private var keyboardHeight: Float?
    private var contact: Contact? {
        return CardManager.default.currentContact
    }

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.dismissKey()
        keyboardNotificationObservers()
        populateWithContact()
        view.viewOfType(type: UITextField.self) { (textfield) in
            textfield.delegate = self
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController = segue.destination as? ConfirmDetailsViewController
        guard let cardImage = self.companyImage else {return}
        destinationController!.cardImage = cardImage

    }

// MARK: - Actions
    @IBAction func backBarButtonPressed(_ sender: Any) {
        saveCardData()

        dismiss(animated: true, completion: nil)
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        saveCardData()
        performSegue(withIdentifier: K.Segues.workInfoToConfirmDetails, sender: self)
    }

// MARK: - Custom methods
    @objc private func handleKeyboardShow(notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.keyboardHeight = Float(keyboardRectangle.height)
        }
    }

    private func populateWithContact() {
        workLocationTextField.text = contact?.businessInfo?.companyAddress
        companyNameTextField.text = contact?.businessInfo?.companyName
        jobTitleTextField.text = contact?.businessInfo?.role
    }

    private func setupUI() {
        navigationBar.shadowImage = UIImage()
        titleLabel.style(with: K.TextStyles.heading1)
        pageCountLabel.style(with: K.TextStyles.subTitle)
        workInfoSectionLabel.style(with: K.TextStyles.subTitle)
        workLocationLabel.style(with: K.TextStyles.subTitle)

    }

    private func saveCardData() {
        var contact = self.contact
        var businessInfo = BusinessInfo()
        businessInfo.companyName = companyNameTextField.text
        businessInfo.role = jobTitleTextField.text
        businessInfo.companyAddress = workLocationTextField.text
        contact?.businessInfo = businessInfo

        CardManager.default.setContact(with: contact!)

    }

    private func keyboardNotificationObservers() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(handleKeyboardShow(notification:)),
                         name: UIResponder.keyboardDidShowNotification,
                         object: nil)
    }
}

// MARK: - Image picker delegates
extension WorkInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    fileprivate func handleImageUploadError(_ error: Error) {
        let alert = UIAlertController(
            title: "Image upload failed",
            message: "An error occured while uploading you image",
            preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                print(error.localizedDescription)
            })
        )
        self.present(alert, animated: true, completion: nil)
    }

//    func imagePickerController(_ picker: UIImagePickerController,
//    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.editedImage] as? UIImage {
//            dismiss(animated: true)
//            DispatchQueue.main.async {
//                let imageView = UIImageView(image: image)
//                imageView.layer.cornerRadius = 8
//                imageView.contentMode = .scaleAspectFill
//                imageView.clipsToBounds = true
//                self.companyLogoView.addSubview(imageView)
//                imageView.translatesAutoresizingMaskIntoConstraints = false
//                imageView.topAnchor.constraint(equalTo: self.companyLogoView.topAnchor, constant: 0).isActive = true
//                imageView.bottomAnchor.constraint(
                    //    equalTo: self.companyLogoView.bottomAnchor, constant: 0).isActive = true
//                imageView.leadingAnchor.constraint(
//                    equalTo: self.companyLogoView.leadingAnchor, constant: 0).isActive = true
//                imageView.trailingAnchor.constraint(
//                    equalTo: self.companyLogoView.trailingAnchor, constant: 0).isActive = true
//            }
//            self.companyImage = image
//            let storageService = DataStorageService()
//            storageService.uploadImage(image: image, type: .CompanyLogos) { (url, error) in
//                if let error = error {
//                    self.handleImageUploadError(error)
//                } else {
//                    print(url!)
//                    self.contact.businessInfo?.companyLogo = url
//                    CardCreationManager.manager.contact.accept(self.contact)
//                }
//            }
//        }
//    }
}

// MARK: - Textfield delegates
extension WorkInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var point = textField.convert(textField.frame.origin, to: self.scrollView)
        point.x = 0.0

        scrollView.setContentOffset(CGPoint(x: 0, y: 160), animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
}
