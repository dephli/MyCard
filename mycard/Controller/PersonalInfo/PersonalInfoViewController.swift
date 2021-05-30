//
//  PersonalInfoViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/9/20.
//

import UIKit
import RxSwift
import FirebaseStorage

class PersonalInfoViewController: UIViewController,
 SocialMediaStackViewDelegate {

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
    @IBOutlet weak var bottomCaretButton: UIButton!

// MARK: - variables
    var viewModel: PersonalInfoViewModel!
    let slideVc = AvatarImageBottomSheet()
    let phoneNumberObservable = PhoneNumberManager.manager.list.asObservable()
    let socialMediaObservable =
        SocialMediaManger.manager.list.asObservable()
    let imagePicker = UIImagePickerController()
    var keyboardHeight: Float?
    let disposeBag = DisposeBag()

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()
        uiSetup()
        nameSetup()
        nameStackView.viewOfType(type: UITextField.self) { (textfield) in
            textfield.delegate = self
        }
        fullNameTextField.becomeFirstResponder()
        socialMediaListStackView.delegate = self
        disableStackViewConstraints()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.viewModel = PersonalInfoViewModel()
        viewModel.bindHandleError = handleError
        registerKeyboardNotifications()
        populateWithData()
        fullNameTextField.text = viewModel.fullName
        if let avatarUrl = viewModel.avatarUrl {
            avatarImageView.loadThumbnail(urlSting: avatarUrl)
        }
        if viewModel.fullName == "" {
            nextButton.isEnabled = false
        }
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
        viewModel.addNewPhoneNumber()
    }

    @IBAction func addEmailPressed(_ sender: Any) {
        viewModel.addNewEmail()
    }

    @IBAction func socialMediaButtonPressed(_ sender: Any) {
        saveProfileInfo()
        performSegue(withIdentifier: K.Segues.personalInfoToSocialMedia, sender: self)
    }

    @IBAction func photoButtonPressed(_ sender: Any) {
        slideVc.delegate = self
        slideVc.modalPresentationStyle = .custom
        slideVc.transitioningDelegate = self
        self.present(slideVc, animated: true, completion: nil)
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

            UIView.animate(withDuration: 0.3) {[self] in
                if bottomCaretButton.transform == CGAffineTransform.identity {
                    bottomCaretButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                } else {
                    bottomCaretButton.transform = CGAffineTransform(rotationAngle: 0)
                }
                for i in 0 ..< stackViewLength {
                    let view = nameStackView.arrangedSubviews[i]
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
    internal func handleError(error: Error, title: String) {
        self.removeActivityIndicator()
        self.alert(title: title, message: error.localizedDescription)
    }

    internal func handleImageUploadSuccess() {
        self.removeActivityIndicator()
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default
            .removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default
            .removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func registerKeyboardNotifications() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(keyboardWillChange),
                name: UIResponder.keyboardWillShowNotification,
                object: nil)

        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(keyboardWillChange),
                name: UIResponder.keyboardWillHideNotification,
                object: nil)

        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(keyboardWillChange),
                name: UIResponder.keyboardWillChangeFrameNotification,
                object: nil)
    }

    private func disableStackViewConstraints() {
        phoneNumbersStackViewHeightConstraint.isActive = false
        emailListStackviewHeightConstraint.isActive = false
        socialMediaListStackViewHeightConstraint.isActive = false
        profileButtonToSocialMediaLabelConstraint?.isActive = false
        profileButtonToSocialMediaStackViewConstraint?.isActive = false

    }

    func onArrowButtonPressed() {
        performSegue(withIdentifier: K.Segues.personalInfoToSocialMedia, sender: self)
    }

    private func verifyTextFields() {
        populateViewModelNames()
        viewModel.verifyTextFields()
        nextButton.isEnabled = viewModel.nextButtonEnabled
    }
}

extension PersonalInfoViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewWillAppear(true)
    }
}

// MARK: - UI Setup
extension PersonalInfoViewController {
    private func populateWithData() {
        let constraintToLabel = socialMediaButton.topAnchor
            .constraint(
                equalTo: socialMediaLabel.bottomAnchor,
                constant: 14)
        let constraintToStackView = socialMediaButton.topAnchor
            .constraint(
                equalTo: socialMediaListStackView.bottomAnchor,
                constant: 24)
        socialMediaObservable.subscribe { [unowned self] _ in
            constraintToLabel.isActive = viewModel.socialMediaIsEmpty
            constraintToStackView.isActive = !viewModel.socialMediaIsEmpty
            socialMediaListStackView.configure(with: viewModel.socialMedia, type: .creation)
            socialMediaButtonHeightConstraint.constant = viewModel.socialMediaHeightConstraint
            socialMediaButton.isHidden = viewModel.hideSocialMediaButton
        }.disposed(by: disposeBag)

        phoneNumberObservable
            .subscribe(onNext: { [unowned self] numbers in
            phoneNumbersStackView.configure(with: numbers)
        }).disposed(by: disposeBag)

        EmailManager.manager.list
            .asObservable()
            .subscribe { [unowned self] emails in
            emailListStackView.configure(with: emails)
        }.disposed(by: disposeBag)
    }

    private func uiSetup() {
        socialMediaButton.setTitle(with: K.TextStyles.bodyBlue, for: .normal)
        customNavBar.setup(backIndicatorImage: "xmark")
        personalInfoLabel.style(with: K.TextStyles.heading1)
        pageCountLabel.style(with: K.TextStyles.subTitle)
        emailLabel.style(with: K.TextStyles.captionBlack60)
        socialMediaLabel.style(with: K.TextStyles.captionBlack60)

        nameTitleLabel.style(with: K.TextStyles.captionBlack60)
        phoneTitleLabel.style(with: K.TextStyles.captionBlack60)
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
        guard let image = info[.editedImage] as? UIImage else {return}
        avatarImageView.image = image
        viewModel.avatarImage = image
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
        viewModel.fullName = fullNameTextField.text!
        distributeNames(textField)
        verifyTextFields()
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.fullName = fullNameTextField.text!
        distributeNames(textField)
    }

}
// MARK: - Save profile info to contact creation manager
extension PersonalInfoViewController {
    private func saveProfileInfo() {
        populateViewModelNames()
        viewModel.saveProfileInfo()
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
            setAllNames()
        }
    }

    private func splitFullname() {
        viewModel.splitFullname()
        prefixTextField.text = viewModel.prefix
        fullNameTextField.text = viewModel.fullName
        firstNameTextField.text = viewModel.firstName
        lastNameTextField.text = viewModel.lastName
        middleNameTextField.text = viewModel.middleName
        suffixTextField.text = viewModel.suffix
    }

    fileprivate func populateViewModelNames() {
        viewModel.firstName = firstNameTextField.text
        viewModel.lastName = lastNameTextField.text
        viewModel.middleName = middleNameTextField.text
        viewModel.prefix = prefixTextField.text
        viewModel.suffix = suffixTextField.text
    }

    private func setAllNames() {
        populateViewModelNames()
        viewModel.setAllNames()
        DispatchQueue.main.async {[self] in
            fullNameTextField.text = viewModel.fullName
        }
    }
}
// MARK: - UIViewControllerTransitioningDelegate
extension PersonalInfoViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - AvatarImageBottomSheetDelegate
extension PersonalInfoViewController: AvatarImageBottomSheetDelegate {
    func removePhotoPressed() {
        viewModel.avatarUrl = ""
//    set avatar url to an empty string instead of nil because
//    firebase will treat an update with nil as an absence of
//    value hence update will not work
        viewModel.avatarImage = nil
        avatarImageView.image = K.Images.profilePlaceholder
        slideVc.dismiss(animated: true, completion: nil)
    }

    func takePhotoPressed() {
        slideVc.dismiss(animated: true, completion: nil)
        let imagePicker = ImagePickerService()
        imagePicker.selectImage(self, sourceType: .camera)
    }

    func uploadPhotoPressed() {
        slideVc.dismiss(animated: true, completion: nil)
        let imagePicker = ImagePickerService()
        imagePicker.selectImage(self)
    }
}
