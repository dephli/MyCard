//
//  ConfirmDetailsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/21/20.
//

import UIKit
import FirebaseFirestore

class ConfirmDetailsViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var nameInitialsLabel: UILabel!
    @IBOutlet weak var nameInitialsView: UIView!
    @IBOutlet weak var cardJobTitleLabel: UILabel!
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var contactDetailsStackView: ContactDetailsStackView!
    @IBOutlet weak var contactDetailsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var contactSummaryView: UIView!

// MARK: - Variables
    var cardImage: UIImage?
    private var contact: Contact? {
        return CardManager.default.currentContact
    }
    private let contactType = CardManager.default.currentContactType
    private var isOpen = false

// MARK: - Viewcontroller methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        self.dismissKey()

        noteTextField.delegate = self

        populateWithContactData()
        registerKeyboardNotifications()

    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
    }

// MARK: - Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func createCardButtonPressed(_ sender: Any) {
        self.showActivityIndicator()
        var contact = CardManager.default.currentContact

        contact.note = noteTextField.text

        if contactType == .createContactCard {
            createContact(contact)
        } else if contactType == .createPersonalCard {
            createPersonalCard(contact)
        } else if contactType == .editContactCard {
            editContactCard(contact)
        } else if contactType == .editPersonalCard {
            editPersonalCard(contact)
        }
    }

// MARK: - Methods
    private func setupUI() {
        if contactType == .editContactCard || contactType == .editPersonalCard {
            createButton.setTitle("Edit card", for: .normal)

        }
        noteLabel.style(with: K.TextStyles.captionBlack60)
        contactDetailsStackViewHeightConstraint.isActive = false
        customNavigationBar.shadowImage = UIImage()
        let randomColor = UIColor.random
        nameInitialsView.backgroundColor = randomColor
        nameInitialsView.alpha = 0.1
        nameInitialsLabel.textColor = randomColor
        cardJobTitleLabel.style(with: K.TextStyles.subTitle)
        noteTextField.attributedPlaceholder = NSAttributedString(
            string: noteTextField.placeholder!,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(cgColor: K.Colors.Blue!.cgColor)
            ])
    }

    private func registerKeyboardNotifications() {
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

    @objc private func keyboardWillChange(_ notification: Notification) {
        guard let keyboardRectangle = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        if notification.name == UIResponder.keyboardWillShowNotification {
            self.view.frame.origin.y = -keyboardRectangle.height
        } else {
            self.view.frame.origin.y = 0
        }
    }

    private func populateWithContactData() {
        contactDetailsStackView.configure(contact: contact)
        noteTextField.text = contact?.note
        cardNameLabel.text = contact?.name.fullName
        cardJobTitleLabel.text = contact?.businessInfo?.role

        let firstName = contact?.name.firstName?.trimmingCharacters(in: .whitespaces)
        let lastName = contact?.name.lastName?.trimmingCharacters(in: .whitespaces)
        if contact?.name != nil {
            if firstName?.isEmpty == false && lastName?.isEmpty == false {
                nameInitialsLabel.text = "\(contact!.name.firstName!.prefix(1))\(contact!.name.lastName!.prefix(1))"
            } else if firstName?.isEmpty == false && lastName?.isEmpty == true {
                nameInitialsLabel.text = "\(contact!.name.firstName!.prefix(2))"
            } else if firstName?.isEmpty == true && lastName?.isEmpty == false {
                nameInitialsLabel.text = "\(contact!.name.lastName!.prefix(2))"
            }

        }
    }

    private func createContact(_ contact: Contact) {
        FirestoreService.manager.createContact(with: contact) { (error) in
            if let error = error {
                self.alert(title: "Could not create card", message: error.localizedDescription)
            } else {
                self.removeActivityIndicator()
                CardManager.default.reset()

                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func createPersonalCard(_ contact: Contact) {
        FirestoreService.manager.createPersonalCard(with: contact) { (error) in

            if let error = error {
                self.alert(title: "Could not create card", message: error.localizedDescription)
            } else {
                self.removeActivityIndicator()
                CardManager.default.reset()
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func editPersonalCard(_ contact: Contact) {
        FirestoreService.manager.editPersonalCard(contact: contact) { (_, error) in
            if let error = error {
                self.alert(title: "Could not edit card", message: error.localizedDescription)
            } else {
                self.removeActivityIndicator()
                CardManager.default.reset()
                let rootViewController = self.view.window?.rootViewController

                rootViewController?.dismiss(animated: true)
            }
        }
    }

    private func editContactCard(_ contact: Contact) {
        FirestoreService.manager.editContactCard(contact: contact) { (_, error) in
            if let error = error {
                self.alert(title: "Could not edit card", message: error.localizedDescription)
            } else {
                self.removeActivityIndicator()
                CardManager.default.reset()
                let rootViewController = self.view.window?.rootViewController
                rootViewController?.dismiss(animated: true, completion: nil)

            }
        }
    }
}

// MARK: - Textfield delegate
extension ConfirmDetailsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.bottomBorder(color: K.Colors.Blue!, width: 1)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.bottomBorder(color: K.Colors.White!, width: 1)
    }
}
