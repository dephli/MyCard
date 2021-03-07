//
//  CardDetailsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/29/20.
//

import UIKit
import ContactsUI

class CardDetailsViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var nameInitialsLabel: UILabel!
    @IBOutlet weak var nameInitialsView: UIView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var detailsStackView: ContactDetailsStackView!
    @IBOutlet weak var detailsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneButtonLabel: UILabel!
    @IBOutlet weak var mailButtonLabel: UILabel!
    @IBOutlet weak var locationButtonLabel: UILabel!
    @IBOutlet weak var cardViewFaceIndicator1: UIView!
    @IBOutlet weak var cardViewFaceIndicator2: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardRoleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var contactSummaryView: UIView!

// MARK: - Variables
    private let imageView = UIImageView()
    private var isOpen = false
    private var notepoint: CGPoint?
    var contact: Contact?
    var contactImage: UIImage?

// MARK: - Viewcontroller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateViewsWithData()
        self.dismissKey()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleCardDrag))
        cardView.addGestureRecognizer(gesture)
        detailsStackViewHeightConstraint.isActive = false
        detailsStackView.configure(contact: contact)
        setupContactDetails()
        noteTextField.text = contact?.note
        noteTextField.isEnabled = false

    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is QRCodeViewController {
            let cnContact = createContact()
            let vc = segue.destination as? QRCodeViewController
            vc!.cnContact = cnContact
            vc!.contact = contact
        }
    }

// MARK: - Methods

    private func setupUI() {
        let share = UIBarButtonItem(
            image: K.Images.share,
            style: .plain,
            target: self,
            action: #selector(shareButtonPressed))
        share.tintColor = .black

        let more = UIBarButtonItem(
            image: K.Images.more,
            style: .plain,
            target: self,
            action: #selector(moreButtonPressed))
        more.tintColor = .black

        navigationItem.rightBarButtonItems = [more, share]

        let randomColor = UIColor.random
        nameInitialsView.backgroundColor = randomColor
        nameInitialsView.alpha = 0.1
        nameInitialsLabel.textColor = randomColor
        noteTextField.delegate = self

        phoneButtonLabel.style(with: K.TextStyles.captionBlack60)
        mailButtonLabel.style(with: K.TextStyles.captionBlack60)
        locationButtonLabel.style(with: K.TextStyles.captionBlack60)

        noteLabel.style(with: K.TextStyles.captionBlack60)

        noteTextField.bottomBorder(color: K.Colors.White!, width: 1)
        noteTextField.attributedPlaceholder = NSAttributedString(
            string: noteTextField.placeholder!,
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(cgColor: K.Colors.Blue!.cgColor)
            ]
        )

        imageView.loadThumbnail(urlSting: contact?.businessInfo?.companyLogo ?? "")
    }

    private func setupContactDetails() {
        if contact?.name != nil {
            let firstName = contact?.name.firstName
            let lastName = contact?.name.lastName
            if firstName?.isEmpty == false && lastName?.isEmpty == false {
                nameInitialsLabel.text = "\(contact!.name.firstName!.prefix(1))\(contact!.name.lastName!.prefix(1))"
            } else if firstName?.isEmpty == false && lastName?.isEmpty == true {
                nameInitialsLabel.text = "\(contact!.name.firstName!.prefix(2))"
            } else if firstName?.isEmpty == true && lastName?.isEmpty == false {
                nameInitialsLabel.text = "\(contact!.name.lastName!.prefix(2))"
            }

        }
    }

    private func populateViewsWithData() {
        cardNameLabel.text = contact?.name.fullName
        cardRoleLabel.text = contact?.businessInfo?.role

    }

    @objc private func handleCardDrag() {
        DispatchQueue.main.async { [self] in
            if isOpen {
                isOpen.toggle()
                cardView.addSubview(contactSummaryView)
                UIView.transition(
                    with: cardView,
                    duration: 0.3,
                    options: .transitionFlipFromBottom,
                    animations: nil,
                    completion: nil)
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

                UIView.transition(
                    with: cardView,
                    duration: 0.3,
                    options: .transitionFlipFromBottom,
                    animations: nil)

            }
        }
    }

    private func confirmDeletion() {
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [self] (_) in
            self.showActivityIndicator()
            FirestoreService.manager.deleteContactCard(contact: contact!) { (error) in
                self.removeActivityIndicator()

                if let error = error {
                    self.alert(title: "Error", message: error.localizedDescription)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }

            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let alertController = UIAlertController(
            title: "Delete Card",
            message: "Are you sure you want to delete this card?",
            preferredStyle: .alert
        )
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = .black
    }

}

// MARK: - ActionSheet Actions
extension CardDetailsViewController {

    private func addContactToCardCreationmanager() {
        let manager = CardManager.default

        manager.setContactType(type: .editContactCard)
        manager.setContact(with: contact ?? Contact(name: Name()))
        SocialMediaManger.manager.list.accept( contact?.socialMediaProfiles ?? [])
        if let phoneNumbers = contact?.phoneNumbers {
            PhoneNumberManager.manager.list.accept(phoneNumbers)
        }
        if let emails = contact?.emailAddresses {
            EmailManager.manager.list.accept(emails)
        }
    }

    @objc private func shareButtonPressed() {
        let cnContact = createContact()

        let fileManager = FileManager.default
        do {

            let cacheDirectory = try? fileManager
                .url(
                    for: .cachesDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true)

            let fileLocation = cacheDirectory?
                .appendingPathComponent("\(CNContactFormatter().string(from: cnContact)!)").appendingPathExtension("vcf")

            let contactData = try CNContactVCardSerialization.data(with: [cnContact])

            try contactData.write(to: (fileLocation?.absoluteURL)!, options: .atomicWrite)

            let activityVc = UIActivityViewController(activityItems: [fileLocation!], applicationActivities: nil)

            present(activityVc, animated: true, completion: nil)
            self.modalPresentationStyle = .fullScreen
        } catch {
            self.alert(title: "Error", message: error.localizedDescription)
        }
    }

    @objc private func moreButtonPressed() {
//        Edit action
        var image = K.Images.edit

        let editAction = UIAlertAction(
            title: "Edit Card", style: .default) { [self] (_) in
            addContactToCardCreationmanager()
            self.performSegue(withIdentifier: K.Segues.cardDetailsToPersonalInfo, sender: self)
        }
        editAction.setValue(image, forKey: "image")
        editAction.setValue(0, forKey: "titleTextAlignment")

//        Export to contacts action
        image = K.Images.contacts

        let addToContactsAction = UIAlertAction(
            title: "Add to contacts", style: .default) { [self] (_) in
            addToContacts()

        }
        addToContactsAction.setValue(image, forKey: "image")
        addToContactsAction.setValue(0, forKey: "titleTextAlignment")

//        Generate QR code action
        image = K.Images.scanQR
        image?.withTintColor(.black)
        let generateQRAction = UIAlertAction(
            title: "Generate QR Code", style: .default) { [self] (_) in
            self.performSegue(withIdentifier: K.Segues.cardDetailsToQR, sender: self)
        }
        generateQRAction.setValue(image, forKey: "image")
        generateQRAction.setValue(0, forKey: "titleTextAlignment")

//        Delete action =
        let deleteAction = UIAlertAction(title: "Delete card", style: .destructive) { (_) in
            self.confirmDeletion()
        }

        image = K.Images.delete
        deleteAction.setValue(image, forKey: "image")
        deleteAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let alert = UIAlertController(title: nil, message: nil,
              preferredStyle: .actionSheet)
        let actions = [editAction, addToContactsAction, generateQRAction, deleteAction, cancelAction]

        for action in actions { alert.addAction(action)}

        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = .black

    }

    private func filteredPhoneNumbers(_ phoneContact: CNMutableContact) {
        //        filter contact
        if let phoneNumbers = contact?.phoneNumbers {

            let phoneNumberMap = phoneNumbers.filter({ (phoneNumber) -> Bool in
                return phoneNumber.number != ""
            })
            .map { (phoneNumber) -> CNLabeledValue<CNPhoneNumber> in
                var contactPhoneNumber: Any?

                if phoneNumber.type == .Home {
                    contactPhoneNumber = CNLabeledValue(
                        label: CNLabelHome,
                        value: CNPhoneNumber(stringValue: phoneNumber.number ?? ""))
                } else if phoneNumber.type == .Mobile {
                    contactPhoneNumber = CNLabeledValue(
                        label: CNLabelPhoneNumberMobile,
                        value: CNPhoneNumber(stringValue: phoneNumber.number ?? ""))
                } else if phoneNumber.type == .Work {
                    contactPhoneNumber = CNLabeledValue(
                        label: CNLabelWork,
                        value: CNPhoneNumber(stringValue: phoneNumber.number ?? ""))
                } else if phoneNumber.type == .Other {
                    contactPhoneNumber = CNLabeledValue(
                        label: CNLabelOther,
                        value: CNPhoneNumber(stringValue: phoneNumber.number ?? ""))
                }

                return contactPhoneNumber as! CNLabeledValue<CNPhoneNumber>
            }
            if !phoneNumberMap.isEmpty {
                phoneContact.phoneNumbers = phoneNumberMap
            }
        }
    }

    private func filteredEmails(_ phoneContact: CNMutableContact) {
        //        filter emails
        if let emails = contact?.emailAddresses {
            let emailMap = emails.map { (email) -> CNLabeledValue<NSString> in
                var contactEmail: Any?
                if email.type == .Work {
                    contactEmail = CNLabeledValue(label: CNLabelWork, value: email.address as NSString)
                } else if email.type == .Personal {
                    contactEmail = CNLabeledValue(label: CNLabelHome, value: email.address as NSString)
                } else if email.type == .Other {
                    contactEmail = CNLabeledValue(label: CNLabelOther, value: email.address as NSString)
                }
                return contactEmail as! CNLabeledValue<NSString>
            }

            phoneContact.emailAddresses = emailMap
        }
    }

    private func createContact () -> CNMutableContact {
        let phoneContact = CNMutableContact()
//        CNContactVCardSerialization.data

        phoneContact.familyName = contact?.name.lastName ?? ""
        phoneContact.givenName = contact?.name.firstName ?? ""
        phoneContact.jobTitle = contact?.businessInfo?.role ?? ""
        phoneContact.note = contact?.note ?? ""
        phoneContact.organizationName = contact?.businessInfo?.companyName ?? ""
        phoneContact.note = contact?.note ?? ""

        if let image = contactImage {
            let imageData = image.jpegData(compressionQuality: 0.5)
            phoneContact.imageData = imageData

        }

        filteredEmails(phoneContact)

        filteredPhoneNumbers(phoneContact)

        return phoneContact
    }

    private func addToContacts() {
        let store = CNContactStore()

        let phoneContact = createContact()

        let saveRequest = CNSaveRequest()
        saveRequest.add(phoneContact, toContainerWithIdentifier: nil)
        do {
            try store.execute(saveRequest)
            self.alert(title: "Success", message: "Exported to contact successfully")

        } catch {
            self.alert(title: "Export failed", message: error.localizedDescription)
        }
    }
}

// MARK: - Textfield delegate
extension CardDetailsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        noteTextField.bottomBorder(color: K.Colors.Blue!, width: 1)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        noteTextField.bottomBorder(color: K.Colors.White!, width: 1)
    }
}
