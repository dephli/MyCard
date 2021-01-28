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
    @IBOutlet weak var phoneNumberTypeLabel: UILabel!
    
    
    @IBOutlet weak var cardViewFaceIndicator1: UIView!
    @IBOutlet weak var cardViewFaceIndicator2: UIView!
    
    @IBOutlet weak var socialMediaStackView: SocialMediaListStackView!
    @IBOutlet weak var socialMediaStackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var phoneTextLabel: UILabel!
    @IBOutlet weak var emailTextLabel: UILabel!
    @IBOutlet weak var emailTypeLabel: UILabel!
    @IBOutlet weak var workInfoTextLabel: UILabel!
    @IBOutlet weak var workLocationTextLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var contactSummaryView: UIView!
    
    let db = Firestore.firestore()
    
    
    var cardImage: UIImage?
    
    var isOpen = false
    
    fileprivate func setupUI() {
        socialMediaStackViewHeightConstraint.isActive = false
//        socialMediaStackView.configure(with: [])
        customNavigationBar.shadowImage = UIImage()
        let randomColor = UIColor.random
        nameInitialsView.backgroundColor = randomColor
        nameInitialsView.alpha = 0.1
        nameInitialsLabel.textColor = randomColor
        nameLabel.style(with: K.TextStyles.bodyBlackSemiBold)
        cardJobTitleLabel.style(with: K.TextStyles.subTitle)
        noteTextField.attributedPlaceholder = NSAttributedString(string: noteTextField.placeholder!, attributes: [
                                                                    NSAttributedString.Key.foregroundColor: UIColor(cgColor: UIColor(named: K.Colors.mcBlue)!.cgColor)])
        
        phoneLabel.style(with: K.TextStyles.subTitle)
        nameLabel.style(with: K.TextStyles.subTitle)
        noteLabel.style(with: K.TextStyles.subTitle)
        workInfoLabel.style(with: K.TextStyles.subTitle)
        workLocationLabel.style(with: K.TextStyles.subTitle)
        emailAddressLabel.style(with: K.TextStyles.subTitle)
        socialMediaLabel.style(with: K.TextStyles.subTitle)

        
        nameTextLabel.style(with: K.TextStyles.bodyBlack)
        phoneTextLabel.style(with: K.TextStyles.bodyBlack)
        emailTextLabel.style(with: K.TextStyles.bodyBlack)
        workInfoTextLabel.style(with: K.TextStyles.bodyBlack)
        workLocationTextLabel.style(with: K.TextStyles.bodyBlack)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleCardDrag))
        self.dismissKey()
        
        gesture.direction = .down
        cardView.addGestureRecognizer(gesture)
        noteTextField.delegate = self
        
        populateWithContactData()
        
    }
    
    @objc func handleCardDrag() {
        if let image = self.cardImage {
            let imageView = UIImageView(image: image)
            
            DispatchQueue.main.async { [self] in
                if isOpen {
                    isOpen.toggle()
                    cardView.addSubview(contactSummaryView)
                    UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromBottom, animations: nil, completion: nil)
                    cardViewFaceIndicator1.backgroundColor = UIColor(named: K.Colors.mcBlack)
                    cardViewFaceIndicator2.backgroundColor = UIColor(named: K.Colors.mcBlack10)
                    
                } else {
                    
                    isOpen.toggle()
                    
                    cardViewFaceIndicator2.backgroundColor = UIColor(named: K.Colors.mcBlack)
                    cardViewFaceIndicator1.backgroundColor = UIColor(named: K.Colors.mcBlack10)

                    
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
        if contact.phoneNumbers.count >= 1 {
            phoneTextLabel.text = contact.phoneNumbers[0].number
            phoneNumberTypeLabel.text = contact.phoneNumbers[0].type.rawValue
        }
        
        if !contact.emailAddresses.isEmpty {
            emailTextLabel.text = contact.emailAddresses[0].address
            emailTypeLabel.text = contact.emailAddresses[0].type.rawValue
        }
        
        workInfoTextLabel.text = contact.businessInfo.companyName
        jobTitleLabel.text = contact.businessInfo.role
        socialMediaStackView.configure(with: contact.socialMediaProfiles)
        workLocationTextLabel.text = contact.businessInfo.companyLocation
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
        
    }
    
    
    @IBAction func createCardButtonPressed(_ sender: Any) {
        var contact = ContactCreationManager.manager.contact.value
        contact.note = noteTextField.text
        do {
            let result = try db.collection(K.Firestore.collectionName).addDocument(from: contact)
            print(result)
            self.navigationController?.popToRootViewController(animated: true)
            self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)

        } catch {
            print(error.localizedDescription)
        }
        
    }
}

extension ConfirmDetailsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.bottomBorder(color: UIColor(named: K.Colors.mcBlue)!, width: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.bottomBorder(color: UIColor(named: K.Colors.mcWhite)!, width: 1)
    }
}
