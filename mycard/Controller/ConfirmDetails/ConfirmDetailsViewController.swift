//
//  ConfirmDetailsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/21/20.
//

import UIKit

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
        noteTextField.bottomBorder(color: UIColor(named: K.Colors.mcBlue)!, width: 1)
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
        
        gesture.direction = .down
        cardView.addGestureRecognizer(gesture)
        
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
        
        cardNameLabel.text = contact.fullName
        cardJobTitleLabel.text = contact.jobTitle
        nameTextLabel.text = contact.fullName
        if contact.phoneNumber.count >= 1 {
            phoneTextLabel.text = contact.phoneNumber[0].number
            phoneNumberTypeLabel.text = contact.phoneNumber[0].type?.rawValue
        }
        
        if !contact.emailAddress.isEmpty {
            emailTextLabel.text = contact.emailAddress[0].address
            emailTypeLabel.text = contact.emailAddress[0].type
        }
        
        workInfoTextLabel.text = contact.companyName
        jobTitleLabel.text = contact.jobTitle
        socialMediaStackView.configure(with: contact.socialMedia)
        workLocationTextLabel.text = contact.companyLocation
//        let contactArray = contact.fullName?.components(separatedBy: " ")
        if contact.lastName != "" && contact.firstName! != "" {
            nameInitialsLabel.text = "\(contact.firstName!.prefix(1))\(contact.lastName!.prefix(1))"
        }
        else if contact.firstName == "" && contact.lastName != "" {
            nameInitialsLabel.text = "\(contact.lastName!.prefix(2))"
        }
        else if contact.lastName == "" && contact.firstName != "" {
            nameInitialsLabel.text = "\(contact.firstName!.prefix(2))"
        } else {
            nameInitialsLabel.text = "ZZ"
        }
    }
}
