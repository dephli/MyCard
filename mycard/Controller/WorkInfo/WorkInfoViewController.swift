//
//  WorkInfoViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/20/20.
//

import UIKit

class WorkInfoViewController: UIViewController {

    @IBOutlet weak var navigationBar: CustomNavigationBar!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var workInfoSectionLabel: UILabel!
    @IBOutlet weak var workLocationLabel: UILabel!
    @IBOutlet weak var companyLogoView: UIView!
    @IBOutlet weak var continueButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var workLocationTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let imagePicker = UIImagePickerController()
    var companyImage: UIImage?
    var keyboardHeight: Float?
    var contact: Contact = ContactCreationManager.manager.contact.value
    
    
    fileprivate func keyboardNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.dismissKey()
        keyboardNotificationObservers()
        view.viewOfType(type: UITextField.self) { (textfield) in
            textfield.delegate = self
        }
    }
    
    @objc func handleKeyboardShow(notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.keyboardHeight = Float(keyboardRectangle.height)
        }
    }
    

    @IBAction func backBarButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadPhotoButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        contact.businessInfo.companyName = companyNameTextField.text!
        contact.businessInfo.role = jobTitleTextField.text!
        contact.businessInfo.companyAddress = workLocationTextField.text!
//        contact.businessInfo.companyLogo =
        
        ContactCreationManager.manager.contact.accept(contact)
        performSegue(withIdentifier: K.Segues.workInfoToConfirmDetails, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController = segue.destination as? ConfirmDetailsViewController
        guard let cardImage = self.companyImage else {return}
        destinationController!.cardImage = cardImage

    }
}

extension WorkInfoViewController {
    func setupUI() {
        navigationBar.shadowImage = UIImage()
        titleLabel.style(with: K.TextStyles.heading1)
        pageCountLabel.style(with: K.TextStyles.subTitle)
        workInfoSectionLabel.style(with: K.TextStyles.subTitle)
        workLocationLabel.style(with: K.TextStyles.subTitle)
        infoLabel.style(with: K.TextStyles.subTitleBlue)
        
        workLocationTextField.text = contact.businessInfo.companyAddress
        companyNameTextField.text = contact.businessInfo.companyName
        jobTitleTextField.text = contact.businessInfo.role
        
    }
}

extension WorkInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    fileprivate func handleImageUploadError(_ error: Error) {
//        Catch error and return it in an alert dialog
        let alert = UIAlertController(title: "Image upload failed", message: "An error occured while uploading you image", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                print(error.localizedDescription)
            } )
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            dismiss(animated: true)
            DispatchQueue.main.async {
                let imageView = UIImageView(image: image)
                imageView.layer.cornerRadius = 8
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                self.companyLogoView.addSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.topAnchor.constraint(equalTo: self.companyLogoView.topAnchor, constant: 0).isActive = true
                imageView.bottomAnchor.constraint(equalTo: self.companyLogoView.bottomAnchor, constant: 0).isActive = true
                imageView.leadingAnchor.constraint(equalTo: self.companyLogoView.leadingAnchor, constant: 0).isActive = true
                imageView.trailingAnchor.constraint(equalTo: self.companyLogoView.trailingAnchor, constant: 0).isActive = true
            }
            self.companyImage = image
            let storageService = DataStorageService()
            storageService.uploadImage(image: image) { (url, error) in
                if let error = error {
                    self.handleImageUploadError(error)
                } else {
                    print(url!)
                    self.contact.businessInfo.companyLogo = url
                    ContactCreationManager.manager.contact.accept(self.contact)
                }
            }
        }
    }
}


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
