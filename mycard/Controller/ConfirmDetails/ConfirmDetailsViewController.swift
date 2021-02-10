//
//  ConfirmDetailsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/21/20.
//

import UIKit
import FirebaseFirestore

class ConfirmDetailsViewController: UIViewController {

    @IBOutlet weak var nameInitialsLabel: UILabel!
    @IBOutlet weak var nameInitialsView: UIView!
    @IBOutlet weak var cardJobTitleLabel: UILabel!
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardNameLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var workInfoLabel: UILabel!
    @IBOutlet weak var workLocationLabel: UILabel!
    @IBOutlet weak var socialMediaLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneNumberStackView: DetailsMultiPhoneEmailStackView!
    
    @IBOutlet weak var emailStackView: DetailsMultiPhoneEmailStackView!
    
    @IBOutlet weak var cardViewFaceIndicator1: UIView!
    @IBOutlet weak var cardViewFaceIndicator2: UIView!
    
    @IBOutlet weak var socialMediaStackView: SocialMediaListStackView!
    @IBOutlet weak var socialMediaStackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextLabel: UILabel!

    @IBOutlet weak var workInfoTextLabel: UILabel!
    @IBOutlet weak var workLocationTextLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var contactSummaryView: UIView!
    
    @IBOutlet weak var phoneNumberStackViewHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailStackViewHeightConstraint: NSLayoutConstraint!
    
    
    let db = Firestore.firestore()
    
    
    var cardImage: UIImage?
    
    var isOpen = false
    
    fileprivate func setupUI() {
        phoneNumberStackViewHeightContraint.isActive = false
        emailStackViewHeightConstraint.isActive = false
        socialMediaStackViewHeightConstraint.isActive = false
        customNavigationBar.shadowImage = UIImage()
        let randomColor = UIColor.random
        nameInitialsView.backgroundColor = randomColor
        nameInitialsView.alpha = 0.1
        nameInitialsLabel.textColor = randomColor
        nameLabel.style(with: K.TextStyles.bodyBlackSemiBold)
        cardJobTitleLabel.style(with: K.TextStyles.subTitle)
        noteTextField.attributedPlaceholder = NSAttributedString(string: noteTextField.placeholder!, attributes: [
                                                                    NSAttributedString.Key.foregroundColor: UIColor(cgColor: K.Colors.Blue!.cgColor)])
        
        let titleLabels = [
            phoneLabel,
            nameLabel,
            noteLabel,
            workInfoLabel,
            workLocationLabel,
            emailAddressLabel,
            socialMediaLabel,
        ]
        
        for label in titleLabels {
            label?.style(with: K.TextStyles.captionBlack60)
        }
        
        let textLabels = [nameTextLabel, workInfoTextLabel, workLocationTextLabel]
        
        for label in textLabels {
            label?.style(with: K.TextStyles.bodyBlack)
        }

    }
    
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleCardDrag))
        self.dismissKey()
        
        cardView.addGestureRecognizer(gesture)
        noteTextField.delegate = self
        
        populateWithContactData()
        registerKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {
        guard let keyboardRectangle = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            self.view.frame.origin.y = -keyboardRectangle.height
        } else {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleCardDrag() {
        if let image = self.cardImage {
            let imageView = UIImageView(image: image)
            
            DispatchQueue.main.async { [self] in
                if isOpen {
                    isOpen.toggle()
                    cardView.addSubview(contactSummaryView)
                    UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromBottom, animations: nil, completion: nil)
                    cardViewFaceIndicator1.backgroundColor = K.Colors.Black
                    cardViewFaceIndicator2.backgroundColor = K.Colors.Black10
                    
                } else {
                    
                    isOpen.toggle()
                    
                    cardViewFaceIndicator2.backgroundColor = K.Colors.Black
                    cardViewFaceIndicator1.backgroundColor = K.Colors.Black10
                    
                    imageView.layer.cornerRadius = 8
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    cardView.addSubview(imageView)
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 0).isActive = true
                    imageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 0).isActive = true
                    imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 0).isActive = true
                    imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 0).isActive = true
                    
                    UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromBottom, animations: nil, completion: nil)

                }
            }
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func populateWithContactData() {
        let contact:Contact = ContactCreationManager.manager.contact.value
        
        cardNameLabel.text = contact.name.fullName
        cardJobTitleLabel.text = contact.businessInfo.role
        nameTextLabel.text = contact.name.fullName

        
        workInfoTextLabel.text = contact.businessInfo.companyName
        jobTitleLabel.text = contact.businessInfo.role
        socialMediaStackView.configure(with: contact.socialMediaProfiles)
        workLocationTextLabel.text = contact.businessInfo.companyAddress
        if contact.name.lastName != "" && contact.name.firstName! != "" {
            nameInitialsLabel.text = "\(contact.name.firstName!.prefix(1))\(contact.name.lastName!.prefix(1))"
        }
        else if contact.name.firstName == "" && contact.name.lastName != "" {
            nameInitialsLabel.text = "\(contact.name.lastName!.prefix(2))"
        }
        else if contact.name.lastName == "" && contact.name.firstName != "" {
            nameInitialsLabel.text = "\(contact.name.firstName!.prefix(2))"
        } else {
            nameInitialsLabel.text = "ZZ"
        }
        
        phoneNumberStackView.configure(with: contact.phoneNumbers)
        emailStackView.configure(with: contact.emailAddresses)
    }
    
    
    @IBAction func createCardButtonPressed(_ sender: Any) {
        self.showActivityIndicator()
        var contact = ContactCreationManager.manager.contact.value
        
        contact.note = noteTextField.text
        
        FirestoreService().createContact(with: contact) { (error) in
            if let error = error {
                self.alert(title: "Could not create card", message: error.localizedDescription)
            } else {
                self.removeActivityIndicator()
                self.navigationController?.popToRootViewController(animated: true)
                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension ConfirmDetailsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.bottomBorder(color: K.Colors.Blue!, width: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.bottomBorder(color: K.Colors.White!, width: 1)
    }
}
