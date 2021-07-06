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
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var detailsStackView: ContactDetailsStackView!
    @IBOutlet weak var detailsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneButtonLabel: UILabel!
    @IBOutlet weak var mailButtonLabel: UILabel!
    @IBOutlet weak var locationButtonLabel: UILabel!
    @IBOutlet weak var cardViewFaceIndicator1: UIView!
    @IBOutlet weak var cardViewFaceIndicator2: UIView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardRoleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noteTextField: UILabel!
    @IBOutlet weak var contactSummaryView: UIView!
    @IBOutlet weak var noteView: UIView!

// MARK: - Variables
    private let imageView = UIImageView()
    private var isOpen = false
    private var notepoint: CGPoint?
    var viewModel: CardDetailsViewModel!

// MARK: - Viewcontroller methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.setHidesBackButton(false, animated: true)
        populateViewsWithData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bindError = handleError
        viewModel.bindTriggerEmailList = emailActionTriggered
        viewModel.bindTriggerPhoneNumberList = phoneNumberActionTriggered
        viewModel.bindCardDeleted = handleCardDeleted
        setupUI()
        self.dismissKey()
        detailsStackViewHeightConstraint.isActive = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(notesViewTapped))
        noteView.addGestureRecognizer(tapGestureRecognizer)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is QRCodeViewController {
            let cnContact = viewModel.createCNContact()
            let vc = segue.destination as? QRCodeViewController
            vc!.cnContact = cnContact
            vc!.contact = viewModel.contact
        } else if segue.destination is NotesViewController {
            let vc = segue.destination as! NotesViewController
            vc.viewModel = NotesViewModel(directEdit: true)
            vc.presentationController?.delegate = self
        }
    }

// MARK: - Actions
    @IBAction func phoneButtonPressed(_ sender: UIButton) {
        viewModel.phoneAction()
    }

    @IBAction func mailButtonPressed(_ sender: UIButton) {
        viewModel.mailAction()
    }

    @IBAction func addressButtonPressed(_ sender: Any) {
        viewModel.addressAction()
    }

    func emailActionTriggered(emailAddresses: [Email]) {
        let alertController = UIAlertController(
            title: "SELECT EMAIL ADDRESS",
            message: "",
            preferredStyle: .actionSheet
        )

        alertController.view.tintColor = .black

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

       emailAddresses.forEach {[self] (email: Email) in
             let action = UIAlertAction(title: email.address, style: .default) { _ in
                viewModel.openEmail(emailAddress: email.address)
            }
        action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            alertController.addAction(action)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func phoneNumberActionTriggered(numbers: [PhoneNumber]) {
        let alertController = UIAlertController(
            title: "SELECT PHONE NUMBER",
            message: "",
            preferredStyle: .actionSheet
        )
        alertController.view.tintColor = .black

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

       numbers.forEach { (phoneNumber: PhoneNumber) in
        let action = UIAlertAction(title: phoneNumber.number, style: .default) { _ in
                self.viewModel.callNumber(number: phoneNumber.number!)
            }
        action.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            alertController.addAction(action)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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

        navigationItem.rightBarButtonItems = [more]

        let randomColor = UIColor.random
        nameInitialsView.backgroundColor = randomColor
        nameInitialsView.alpha = 0.1
        nameInitialsLabel.textColor = randomColor

        phoneButtonLabel.style(with: K.TextStyles.captionBlack60)
        mailButtonLabel.style(with: K.TextStyles.captionBlack60)
        locationButtonLabel.style(with: K.TextStyles.captionBlack60)
        imageView.loadThumbnail(urlSting: viewModel.contact.businessInfo?.companyLogo ?? "")
    }

    private func populateViewsWithData() {
        cardNameLabel.text = viewModel.fullName
        cardRoleLabel.text = viewModel.role
        noteTextField.text = viewModel.note
        noteTextField.textColor = viewModel.noteTextColor
        nameInitialsLabel.text = viewModel.nameInitials
        if let avatarImageUrl = viewModel.avatarImageUrl {
            avatarImageView.loadThumbnail(urlSting: avatarImageUrl)
        }
        detailsStackView.configure(contact: viewModel.contact)
    }

    @objc private func notesViewTapped() {
        viewModel.editNote()
        performSegue(withIdentifier: K.Segues.cardDetailsToNotes, sender: self)
    }

    func handleError(error: Error) {
        alert(title: "Oops", message: error.localizedDescription)
    }

    private func confirmDeletion() {
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [self] (_) in
            self.showActivityIndicator()
            viewModel.deleteCard()
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

    private func handleCardDeleted() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}

// MARK: - ActionSheet Actions
extension CardDetailsViewController {
    @objc private func shareButtonPressed() {
        let cnContact = viewModel.createCNContact()

        let fileManager = FileManager.default
        do {
            let cacheDirectory = try fileManager
                .url(
                    for: .cachesDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true)

            let fileLocation = cacheDirectory
                .appendingPathComponent("\(CNContactFormatter().string(from: cnContact)!)")
                .appendingPathExtension("vcf")

            let contactData = try CNContactVCardSerialization.data(with: [cnContact])

            try contactData.write(to: (fileLocation.absoluteURL), options: .atomicWrite)

            let activityVc = UIActivityViewController(activityItems: [fileLocation], applicationActivities: nil)

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
            viewModel!.addContactToCardManager()
            self.performSegue(withIdentifier: K.Segues.cardDetailsToPersonalInfo, sender: self)
        }
        editAction.setValue(image, forKey: "image")
        editAction.setValue(0, forKey: "titleTextAlignment")

//        Export to contacts action
        image = K.Images.contacts
        let addToContactsAction = UIAlertAction(
            title: "Export to Contacts", style: .default) { [self] (_) in
            exportToContacts()
        }
        addToContactsAction.setValue(image, forKey: "image")
        addToContactsAction.setValue(0, forKey: "titleTextAlignment")

//        Generate QR code action
        image = K.Images.scanQR

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

//        Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let alertController = UIAlertController(title: nil, message: nil,
              preferredStyle: .actionSheet)
        alertController.view.tintColor = .black
        let actions = [editAction, addToContactsAction, deleteAction, cancelAction]

        for action in actions { alertController.addAction(action)}
        self.present(alertController, animated: true, completion: nil)
    }

    private func exportToContacts() {
        let store = CNContactStore()

        let phoneContact = viewModel.createCNContact()
        let contactVc = CNContactViewController(forUnknownContact: phoneContact)
        contactVc.contactStore = store
        contactVc.delegate = self
        contactVc.allowsActions = false
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(contactVc, animated: true)
        hidesBottomBarWhenPushed = false
    }
}

extension CardDetailsViewController: CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        navigationController?.popViewController(animated: true)
    }
}

extension CardDetailsViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewWillAppear(true)
    }
}
