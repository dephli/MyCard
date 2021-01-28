//
//  PersonalInfoViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/9/20.
//

import UIKit
import RxSwift
import FirebaseStorage

class PersonalInfoViewController: UIViewController {
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var socialMediaLabel: UILabel!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var prefixTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var suffixTextField: UITextField!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var socialMediaButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var phoneNumbersStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailListStackviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var socialMediaListStackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var phoneNumbersStackView: PhoneListStackView!
    @IBOutlet weak var emailListStackView: EmailListStackView!
    @IBOutlet weak var socialMediaListStackView: SocialMediaListStackView!
    
    @IBOutlet weak var profileButtonToSocialMediaLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileButtonToSocialMediaStackViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var customNavBar: CustomNavigationBar!
    
    let phoneNumberObservable = PhoneNumberManager.manager.list.asObservable()
    let socialMediaObservable =
        SocialMediaManger.manager.list.asObservable()
    let disposeBag = DisposeBag()
    
    let imagePicker = UIImagePickerController()
    
    var keyboardHeight: Float?
    
    let prefixTypes = ["mr", "ms", "mrs", "dr"]
    let suffixes = ["phd", "ccna", "obe", "sr", "jr", "i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x", "snr"]
    var userDefinedPrefixType: [String] = []
    var previousPrefix = ""
    var previousFirstName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKey()
        
        uiSetup()

        nameSetup()
        
            userDefinedPrefixType = prefixTypes
        
        view.viewOfType(type: UITextField.self) { (textfield) in
            textfield.delegate = self
        }
        
        fullNameTextField.becomeFirstResponder()
        phoneNumbersStackViewHeightConstraint.isActive = false
        emailListStackviewHeightConstraint.isActive = false
        socialMediaListStackViewHeightConstraint.isActive = false
        profileButtonToSocialMediaLabelConstraint?.isActive = false
        profileButtonToSocialMediaStackViewConstraint?.isActive = false
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewPhonePressed(_ sender: Any) {
        PhoneNumberManager.manager.append(with: PhoneNumber(type: .Home, number: ""))
    }
    @IBAction func addEmailPressed(_ sender: Any) {
        EmailManager.manager.append(with: Email(type: .Personal, address: ""))
    }
    @IBAction func socialMediaButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: K.Segues.personalInfoToSocialMedia, sender: self)
    }
    @IBAction func photoButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        saveProfileInfo()
        performSegue(withIdentifier: K.Segues.personalInfoToWorkInfo, sender: self)
    }
}


//MARK: - UI Setup
extension PersonalInfoViewController {
    
    func uiSetup() {
        socialMediaButton.setTitle(with: K.TextStyles.bodyBlue, for: .normal)
        customNavBar.setup(backIndicatorImage: "xmark")
        personalInfoLabel.style(with: K.TextStyles.heading1)
        pageCountLabel.style(with: K.TextStyles.subTitle)
        emailLabel.style(with: K.TextStyles.subTitle)
        socialMediaLabel.style(with: K.TextStyles.subTitle)
        
        nameTitleLabel.style(with: K.TextStyles.captionBlack60)
        phoneTitleLabel.style(with: K.TextStyles.captionBlack60)
        
        phoneNumberObservable.subscribe(onNext: { [unowned self] numbers in
            phoneNumbersStackView.configure(with: numbers)
        }).disposed(by: disposeBag)

        EmailManager.manager.list.asObservable().subscribe { [unowned self] emails in
            emailListStackView.configure(with: emails)
        }.disposed(by: disposeBag)
        
        let constraintToLabel = socialMediaButton.topAnchor.constraint(equalTo: socialMediaLabel.bottomAnchor, constant: 14)
        let constraintToStackView = socialMediaButton.topAnchor.constraint(equalTo: socialMediaListStackView.bottomAnchor, constant: 24)
        socialMediaObservable.subscribe { accounts in
            
            let isEmpty = SocialMediaManger.manager.getAll.isEmpty
            constraintToLabel.isActive = isEmpty
            
            constraintToStackView.isActive = !isEmpty
            
        }.disposed(by: disposeBag)

        
        socialMediaObservable.subscribe { [unowned self] accounts in
            socialMediaListStackView.configure(with: accounts)
        }.disposed(by: disposeBag)

    }
}


//MARK: - Name Setup
extension PersonalInfoViewController {
    func nameSetup() {
        
        let stackViewLength = nameStackView.arrangedSubviews.count
        nameStackView.arrangedSubviews[0].alpha = 1

        for i in 1 ... stackViewLength-1 {
            nameStackView.arrangedSubviews[i].isHidden = true
            nameStackView.arrangedSubviews[i].alpha = 0
        }
    }
    
    @IBAction func bottomCaretButtonPressed(_ sender: UIButton) {
//        distributeNames()
        
        let stackViewLength = nameStackView.arrangedSubviews.count
        
        DispatchQueue.main.async {
                self.nameStackView.arrangedSubviews[0].alpha = 0

            UIView.animate(withDuration: 0.3) {
                for i in 0 ..< stackViewLength{
                    let view = self.nameStackView.arrangedSubviews[i]
                    view.isHidden.toggle()
                    
                
                    if i != 0 {
                        if view.alpha == 0 {
                            view.alpha = 1
                        } else {
                            view.alpha = 0
                        }
                    }
                
                }
            } completion: { completed in
                self.nameStackView.arrangedSubviews[0].alpha = 1
            }

        }
    }
}

extension PersonalInfoViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    fileprivate func handleImageUploadError(_ error: Error) {
        let alert = UIAlertController(title: "Image upload failed", message: "An error occured while uploading you image", preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                print(error.localizedDescription)
            } )
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {return}
        DispatchQueue.main.async {
            self.avatarImageView.image = image
        }
        let storageService = DataStorageService()
        storageService.uploadImage(image: image) { (url, error) in
            if let error = error {
                self.handleImageUploadError(error)
            } else {
                var contact = ContactCreationManager.manager.contact.value
                contact.profilePicUrl = url
                ContactCreationManager.manager.contact.accept(contact)
            }
        }
        
    }
}

extension PersonalInfoViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var point = textField.convert(textField.frame.origin, to: self.scrollView)
        point.x = 0.0
        
        scrollView.setContentOffset(CGPoint(x: 0, y: Int(self.keyboardHeight ?? 0)), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
        distributeNames(textField)
    }
    
    fileprivate func keyboardNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func handleKeyboardShow(notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.keyboardHeight = Float(keyboardRectangle.height)
        }
    }
    
    
}

extension PersonalInfoViewController {
    fileprivate func saveProfileInfo() {
        var contact: Contact = ContactCreationManager.manager.contact.value
        if fullNameTextField.text != "" {
            contact.name.fullName = fullNameTextField.text
        }
        contact.name.firstName = firstNameTextField.text!
        contact.name.lastName = lastNameTextField.text!
        contact.name.middleName = middleNameTextField.text!
        contact.name.prefix = prefixTextField.text!
        contact.name.suffix = suffixTextField.text!
        contact.phoneNumbers = PhoneNumberManager.manager.list.value
        contact.emailAddresses = EmailManager.manager.list.value
        contact.socialMediaProfiles = SocialMediaManger.manager.getAll

        ContactCreationManager.manager.contact.accept(contact)
    }
}


extension PersonalInfoViewController {
    fileprivate func distributeNames(_ textfield: UITextField) {

        if textfield.placeholder == "Full Name" {
            DispatchQueue.main.async {
                self.splitFullname()
            }
        }
        else {
            DispatchQueue.main.async {
                self.setAllNames()
            }
        }
    }
    
    func splitFullname() {
        
        let fullName = fullNameTextField.text!
        if fullName.count > 1 {
                let names = fullName.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
                        for i in 1..<nameStackView.arrangedSubviews.count {
                            (nameStackView.arrangedSubviews[i] as? UITextField)?.text = ""
                        }
                
//                TODO: Refactor this code
            let first = names[0].trimmingCharacters(in: .punctuationCharacters)
                    
//            check if first word is a prefix word
            if prefixTypes.contains(first.trimmingCharacters(in: .punctuationCharacters).lowercased()) {
                prefixTextField.text = first
//                if word is a prefix word and there are two words, set second word to lastName
                        if names.count == 2 {
                            lastNameTextField.text = names[1]
                        }
//                        if word is a prefix and there are 3
                        else if names.count == 3 {
//                            if last word is a suffix word, set suffix to last word and lastname to middle word
                            if suffixes.contains(names[names.count-1].trimmingCharacters(in: .punctuationCharacters).lowercased()) {
                                suffixTextField.text = names[names.count - 1]
                                lastNameTextField.text = names[names.count-2]
                            } else {
//                                else set lastName to last word, first name to middle word
                                firstNameTextField.text = names[names.count-2]
                                lastNameTextField.text = names[names.count-1]
                            }
                        }
//                        if there are 4 or more words
                        else if names.count == 4 {
//                            and last word is a suffix word, set lastname to last word,
                            if suffixes.contains(names[names.count-1].trimmingCharacters(in: .punctuationCharacters).lowercased()) {
                                suffixTextField.text = names[names.count - 1]
                                lastNameTextField.text = names[names.count-2]
                                firstNameTextField.text = names[names.count-3]
//                                firstNameTextField.text = names[1..<names.count-3].joined(separator: " ")
                            } else {
                                lastNameTextField.text = names[names.count-1]
                                middleNameTextField.text = names[names.count-2]
                                firstNameTextField.text = names[names.count - 3]
                            }
                        }
                        else {
                            if suffixes.contains(names[names.count-1].trimmingCharacters(in: .punctuationCharacters).lowercased()) {
                                suffixTextField.text = names[names.count - 1]
                                lastNameTextField.text = names[names.count-2]
                                middleNameTextField.text = names[names.count-3]
                                firstNameTextField.text = names[1..<names.count-3].joined(separator: " ")
                            } else {
                                lastNameTextField.text = names[names.count-1]
                                middleNameTextField.text = names[names.count-2]
                                firstNameTextField.text = names[1..<names.count-2].joined(separator: " ")
                            }
                        }
                
                    } else {
                        let last = names[names.count - 1]
                        if names.count == 2 {
                            firstNameTextField.text = names[0]
                            lastNameTextField.text = names[1]
                        }
                        else if names.count == 3 {
                            if suffixes.contains(last.lowercased().trimmingCharacters(in:.punctuationCharacters)) {
                                suffixTextField.text = last
                                lastNameTextField.text = names[names.count-2]
                                firstNameTextField.text = names[names.count-3]
                            } else {
                                lastNameTextField.text = last
                                middleNameTextField.text = names[names.count-2]
                                firstNameTextField.text = names[0..<names.count-2].joined(separator: " ")
                            }
                        }
                        else {
                            if suffixes.contains(last.lowercased().trimmingCharacters(in:.punctuationCharacters)) {
                                suffixTextField.text = last
                                lastNameTextField.text = names[names.count-2]
                                middleNameTextField.text = names[names.count-3]
                                firstNameTextField.text = names[0..<names.count-3].joined(separator: " ")
                            } else {
                                if names.count == 1 {
                                    firstNameTextField.text = names[0]
                                } else {
                                    lastNameTextField.text = last
                                    middleNameTextField.text = names[names.count-2]
                                    firstNameTextField.text = names[0..<names.count-2].joined(separator: " ")
                                }
                            }
                        }
                    }
            } else {
                prefixTextField.text = ""
                firstNameTextField.text = ""
                lastNameTextField.text = ""
                middleNameTextField.text = ""
                suffixTextField.text = ""
            }
    }
    
    func setAllNames() {
        let prefixText = prefixTextField.text!.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .punctuationCharacters)
        let firstNameText = firstNameTextField.text!.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .punctuationCharacters)
        let middleNameText = middleNameTextField.text!.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .punctuationCharacters)
        let lastNameText = lastNameTextField.text!.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .punctuationCharacters)
        let suffixText = suffixTextField.text!.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .punctuationCharacters)
        
        let prefix = prefixText != "" ? "\(prefixText) " : ""
        let firstName = firstNameText != "" ? "\(firstNameText) " : ""
        let middleName = middleNameText != "" ? "\(middleNameText) " : ""
        let lastName =  lastNameText != "" ? "\(lastNameText) " : ""
        let suffix = suffixText != "" ? "\(suffixText) " : ""
        
        fullNameTextField.text = "\(prefix)\(firstName)\(middleName)\(lastName)\(suffix)"

    }
}
