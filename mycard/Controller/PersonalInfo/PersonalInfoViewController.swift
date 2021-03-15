//
//  PersonalInfoViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/9/20.
//

import UIKit
import RxSwift
import FirebaseStorage

class PersonalInfoViewController
:UIViewController,
 SocialMediaStackViewDelegate{

    // MARK: - Outlets
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
    @IBOutlet weak var socialMediaButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var customNavBar: CustomNavigationBar!

    // MARK: - variables
    let phoneNumberObservable = PhoneNumberManager.manager.list.asObservable()
    let socialMediaObservable =
        SocialMediaManger.manager.list.asObservable()
    let imagePicker = UIImagePickerController()
    var keyboardHeight: Float?
    var contact: Contact? {
        return CardManager.shared.currentEditableContact
    }
    let disposeBag = DisposeBag()

    let prefixTypes = [
        "mr", "ms", "mrs", "dr", "adm", "capt",
        "chief", "cmdr", "col", "gov", "hon",
        "maj", "msgt", "prof", "rev"]
//    this can be updated to get the data from cloud storage
    let suffixes = [
        "phd", "ccna", "obe", "sr", "jr",
        "i", "ii", "iii", "iv", "v", "vi",
        "vii", "viii", "ix", "x", "snr",
        "madame", "jnr" ]
    var userDefinedPrefixType: [String] = []
    var previousPrefix = ""
    var previousFirstName = ""
    var nameArray: [String] {
        let names =  fullNameTextField.text!
            .trimmingCharacters(in: .whitespaces)
            .components(separatedBy: " ")
        let filteredNames = names.filter { (name) -> Bool in
            return name.trimmingCharacters(in: .whitespaces) != ""
        }
        return filteredNames
    }
    var prefixAndFuncMap: [Int: () -> Void ] {
        return [
            1: prefixAndOneWord,
            2: prefixAndTwoWords,
            3: prefixAndThreeWords,
            4: prefixAndFourWords
        ]
    }
    var noPrefixAndFuncMap: [Int: () -> Void ] {
        return [
            1: noPrefixAndOneWord,
            2: noPrefixAndTwoWords,
            3: noPrefixAndThreeWords
        ]
    }

// MARK: - ViewController methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dismissKey()
        uiSetup()
        nameSetup()
        userDefinedPrefixType = prefixTypes
        nameStackView.viewOfType(type: UITextField.self) { (textfield) in
            textfield.delegate = self
        }
        fullNameTextField.becomeFirstResponder()
        fullNameTextField.text = contact?.name.fullName
        if let avatarUrl = contact?.profilePicUrl {
            avatarImageView.loadThumbnail(urlSting: avatarUrl)
        }
        socialMediaListStackView.delegate = self
        disableStackViewConstraints()

        if contact?.name.fullName == "" {
            nextButton.isEnabled = false
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        registerKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObservers()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.personalInfoToSocialMedia {
            self.removeKeyboardObservers()
            segue.destination.presentationController?.delegate = self
        } else {
            if let vc = segue.destination as? WorkInfoViewController {
                vc.viewModel = WorkInfoViewModel()
            }
        }
    }

    // MARK: - Actions

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addNewPhonePressed(_ sender: Any) {
        let phoneNumbers = PhoneNumberManager.manager.list.value

//        you cannot add a phone number if any is empty
        if !phoneNumbers.contains(where: { (phoneNumber) -> Bool in
            return phoneNumber.number!.isEmpty
        }) {
            PhoneNumberManager.manager.append(with: PhoneNumber(type: .Home, number: ""))
        }
    }

    @IBAction func addEmailPressed(_ sender: Any) {
        let emails = EmailManager.manager.list.value

//        you cannot add another email if any is empty
        if !emails.contains(where: { (email) -> Bool in
            return email.address.isEmpty
        }) {
            EmailManager.manager.append(with: Email(type: .Personal, address: ""))
        }
    }

    @IBAction func socialMediaButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: K.Segues.personalInfoToSocialMedia, sender: self)
    }

    @IBAction func photoButtonPressed(_ sender: Any) {
        let imagePicker = ImagePickerService()
        imagePicker.selectImage(self)
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        self.setAllNames()
        saveProfileInfo()
        performSegue(withIdentifier: K.Segues.personalInfoToWorkInfo, sender: self)
    }

    @IBAction func bottomCaretButtonPressed(_ sender: UIButton) {

        let stackViewLength = nameStackView.arrangedSubviews.count
        DispatchQueue.main.async {
                self.nameStackView.arrangedSubviews[0].alpha = 0

            UIView.animate(withDuration: 0.3) {
                for i in 0 ..< stackViewLength {
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
            } completion: { _ in
                self.nameStackView.arrangedSubviews[0].alpha = 1
            }

        }
    }

// MARK: - selector functions

    @objc func keyboardWillChange(_ notification: Notification) {

        if notification.name == UIResponder.keyboardWillShowNotification {
            self.view.frame.origin.y = -200
        } else {
            self.view.frame.origin.y = 0
        }
    }

// MARK: - Custom methods
    func removeKeyboardObservers() {
        NotificationCenter.default
            .removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default
            .removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func registerKeyboardNotifications() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillChange),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)

        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillChange),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)

        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillChange),
                         name: UIResponder.keyboardWillChangeFrameNotification,
                         object: nil)
    }

    func disableStackViewConstraints() {
        phoneNumbersStackViewHeightConstraint.isActive = false
        emailListStackviewHeightConstraint.isActive = false
        socialMediaListStackViewHeightConstraint.isActive = false
        profileButtonToSocialMediaLabelConstraint?.isActive = false
        profileButtonToSocialMediaStackViewConstraint?.isActive = false

    }

    func onArrowButtonPressed() {
        performSegue(withIdentifier: K.Segues.personalInfoToSocialMedia, sender: self)
    }
    
    func verifyTextFields() {
        let firstName = firstNameTextField.text!
                   .trimmingCharacters(in: .whitespaces)
                   .trimmingCharacters(in: .decimalDigits)
        let lastName = lastNameTextField.text!
           .trimmingCharacters(in: .whitespaces)
           .trimmingCharacters(in: .decimalDigits)
        let middleName = middleNameTextField.text!
           .trimmingCharacters(in: .whitespaces)
           .trimmingCharacters(in: .decimalDigits)
        if firstName.isEmpty && middleName.isEmpty && lastName.isEmpty {
           nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
}

extension PersonalInfoViewController
:UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewWillAppear(true)
    }
}

// MARK: - UI Setup
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

        let constraintToLabel = socialMediaButton.topAnchor
            .constraint(
                equalTo: socialMediaLabel.bottomAnchor,
                constant: 14)
        let constraintToStackView = socialMediaButton.topAnchor
            .constraint(
                equalTo: socialMediaListStackView.bottomAnchor,
                constant: 24)

        phoneNumberObservable.subscribe(onNext: { [unowned self] numbers in
            phoneNumbersStackView.configure(with: numbers)
        }).disposed(by: disposeBag)

        EmailManager.manager.list.asObservable().subscribe { [unowned self] emails in
            emailListStackView.configure(with: emails)
        }.disposed(by: disposeBag)

        socialMediaObservable.subscribe { [unowned self] accounts in
            let isEmpty = SocialMediaManger.manager.getAll.isEmpty
            constraintToLabel.isActive = isEmpty

            constraintToStackView.isActive = !isEmpty

            socialMediaListStackView.configure(with: accounts.element ?? [], type: .creation)

            if accounts.element?.count == 4 {
                socialMediaButtonHeightConstraint.constant = 0
                socialMediaButton.isHidden = true
            } else {
                socialMediaButton.isHidden = false
                socialMediaButtonHeightConstraint.constant = 48
            }
        }.disposed(by: disposeBag)

    }

}

// MARK: - Name Setup
extension PersonalInfoViewController {
    func nameSetup() {
        let stackViewLength = nameStackView.arrangedSubviews.count
        nameStackView.arrangedSubviews[0].alpha = 1

        for i in 1 ... stackViewLength-1 {
            nameStackView.arrangedSubviews[i].isHidden = true
            nameStackView.arrangedSubviews[i].alpha = 0
        }
    }

}

// MARK: - Handle image picking and upload
extension PersonalInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)
        self.showActivityIndicator()
        guard let image = info[.editedImage] as? UIImage else {return}
        DataStorageService.uploadImage(image: image, type: .network) { (url, error) in
            self.removeActivityIndicator()
            if let error = error {
                self.alert(title: "Image upload failed", message: error.localizedDescription)

            } else {
//              create local contact as global contact is a get variable
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                }

                var contact = self.contact
                contact?.profilePicUrl = url
                CardManager.shared.currentEditableContact = contact!
            }
        }

    }
}
// MARK: - Textfield delegate
extension PersonalInfoViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        var point = textField.convert(textField.frame.origin, to: self.scrollView)
        point.x = 0.0

        scrollView.setContentOffset(CGPoint(x: 0, y: Int(self.keyboardHeight ?? 0)), animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
        distributeNames(textField)
        verifyTextFields()
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        distributeNames(textField)
    }

}
// MARK: - Save profile info to contact creation manager
extension PersonalInfoViewController {
    private func saveProfileInfo() {
        var contact = self.contact
        if fullNameTextField.text != "" {
            contact?.name.fullName = fullNameTextField.text
        }
        contact?.name.firstName = firstNameTextField.text!
        contact?.name.lastName = lastNameTextField.text!
        contact?.name.middleName = middleNameTextField.text!
        contact?.name.prefix = prefixTextField.text!
        contact?.name.suffix = suffixTextField.text!
        contact?.phoneNumbers = PhoneNumberManager.manager.list.value
        contact?.emailAddresses = EmailManager.manager.list.value
        contact?.socialMediaProfiles = SocialMediaManger.manager.getAll

        CardManager.shared.currentEditableContact = contact!
    }
}

// MARK: - Distribute Names
extension PersonalInfoViewController {
    private func distributeNames(_ textfield: UITextField) {

        if textfield.placeholder == "Full Name" {
            DispatchQueue.main.async {
                self.splitFullname()
            }
        } else {
            DispatchQueue.main.async {
                self.setAllNames()
            }
        }
    }

    private func prefixAndOneWord() {
        prefixTextField.text = nameArray[0]
    }

    private func prefixAndTwoWords() {
        lastNameTextField.text = nameArray[1]
    }

    private func prefixAndThreeWords() {
        let containedText = nameArray[nameArray.count-1].trimmingCharacters(in: .punctuationCharacters).lowercased()

        if suffixes.contains(containedText) {
            suffixTextField.text = nameArray[nameArray.count - 1]
            lastNameTextField.text = nameArray[nameArray.count-2]
        } else {
            firstNameTextField.text = nameArray[nameArray.count-2]
            lastNameTextField.text = nameArray[nameArray.count-1]
        }
    }

    private func prefixAndFourWords() {
        let containedText = nameArray[nameArray.count-1].trimmingCharacters(in: .punctuationCharacters).lowercased()
        if suffixes.contains(containedText) {
            suffixTextField.text = nameArray[nameArray.count - 1]
            lastNameTextField.text = nameArray[nameArray.count-2]
            firstNameTextField.text = nameArray[nameArray.count-3]
        } else {
            lastNameTextField.text = nameArray[nameArray.count-1]
            middleNameTextField.text = nameArray[nameArray.count-2]
            firstNameTextField.text = nameArray[nameArray.count - 3]
        }
    }

    private func prefixAndFiveOrMoreWords() {
        let containedText = nameArray[nameArray.count-1].trimmingCharacters(in: .punctuationCharacters).lowercased()

        if suffixes.contains(containedText) {
            suffixTextField.text = nameArray[nameArray.count - 1]
            lastNameTextField.text = nameArray[nameArray.count-2]
            middleNameTextField.text = nameArray[nameArray.count-3]
            firstNameTextField.text = nameArray[1..<nameArray.count-3].joined(separator: " ")
        } else {
            lastNameTextField.text = nameArray[nameArray.count-1]
            middleNameTextField.text = nameArray[nameArray.count-2]
            firstNameTextField.text = nameArray[1..<nameArray.count-2].joined(separator: " ")
        }
    }

    private func noPrefixAndOneWord() {
        firstNameTextField.text = nameArray[0]
    }

    private func noPrefixAndTwoWords() {
        firstNameTextField.text = nameArray[0]
        lastNameTextField.text = nameArray[1]
    }

    private func noPrefixAndThreeWords() {
        let last = nameArray[nameArray.count - 1]

        if suffixes.contains(last.lowercased().trimmingCharacters(in: .punctuationCharacters)) {
            suffixTextField.text = last
            lastNameTextField.text = nameArray[nameArray.count-2]
            firstNameTextField.text = nameArray[nameArray.count-3]
        } else {
            lastNameTextField.text = last
            middleNameTextField.text = nameArray[nameArray.count-2]
            firstNameTextField.text = nameArray[0..<nameArray.count-2].joined(separator: " ")
        }
    }

    private func noPrefixAndFourOrMoreWords() {
        let last = nameArray[nameArray.count - 1]
        if suffixes.contains(last.lowercased().trimmingCharacters(in: .punctuationCharacters)) {
            suffixTextField.text = last
            lastNameTextField.text = nameArray[nameArray.count-2]
            middleNameTextField.text = nameArray[nameArray.count-3]
            firstNameTextField.text = nameArray[0..<nameArray.count-3].joined(separator: " ")
        } else {
            lastNameTextField.text = last
            middleNameTextField.text = nameArray[nameArray.count-2]
            firstNameTextField.text = nameArray[0..<nameArray.count-2].joined(separator: " ")
        }
    }

    private func resetTextFieldContents() {
        //            resetTextFieldContents
        for i in 1..<nameStackView.arrangedSubviews.count {
            (nameStackView.arrangedSubviews[i] as? UITextField)?.text = ""
        }
    }

    private func splitFullname() {

        let fullName = fullNameTextField.text!.trimmingCharacters(in: .whitespaces)
        if fullName.count > 1 {

            resetTextFieldContents()

            let first = nameArray[0].trimmingCharacters(in: .punctuationCharacters)

            if prefixTypes.contains(first.trimmingCharacters(in: .punctuationCharacters).lowercased()) {
                prefixTextField.text = first

                if nameArray.count > 4 {
                    prefixAndFiveOrMoreWords()
                } else {
                    guard let mapFunc = prefixAndFuncMap[nameArray.count] else { return  }
                    mapFunc()
                }

            } else {
                if nameArray.count > 3 {
                    noPrefixAndFourOrMoreWords()
                } else {
                    guard let mapFunc = noPrefixAndFuncMap[nameArray.count] else { return }
                    mapFunc()
                }
            }
        } else {
            resetTextFieldContents()
        }
    }

    private func setAllNames() {
        let prefixText = prefixTextField.text!
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: .punctuationCharacters)
        let firstNameText = firstNameTextField.text!
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: .punctuationCharacters)
        let middleNameText = middleNameTextField.text!
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: .punctuationCharacters)
        let lastNameText = lastNameTextField.text!
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: .punctuationCharacters)
        let suffixText = suffixTextField.text!
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: .punctuationCharacters)

        let prefix = prefixText != "" ? "\(prefixText) " : ""
        let firstName = firstNameText != "" ? "\(firstNameText) " : ""
        let middleName = middleNameText != "" ? "\(middleNameText) " : ""
        let lastName =  lastNameText != "" ? "\(lastNameText) " : ""
        let suffix = suffixText != "" ? "\(suffixText) " : ""

        fullNameTextField.text = "\(prefix)\(firstName)\(middleName)\(lastName)\(suffix)"

    }
}
