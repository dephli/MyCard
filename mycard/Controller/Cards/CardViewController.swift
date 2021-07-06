//
//  CardViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/7/20.
//

import UIKit
import ContactsUI

class CardViewController: UIViewController {
    enum SortBy {
        case recentlyAdded
        case name
    }

// MARK: - Outlets
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var emptyCardsView: UIView!

// MARK: - Variables
    private var aView: UIView?
    private var contacts: [Contact] = []
    private var sortedBy: SortBy = .recentlyAdded
    var viewModel: CardViewModel!
    let addCardBottomSheet = AddCardBottomSheet()

// MARK: - ViewController methods
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CardViewModel()
        viewModel.bindError = handleError
        viewModel.bindContactsRetrievalSuccess = contactsRetrievalSuccessful
        self.showActivityIndicator()
        cardTableView.isHidden = true
        emptyCardsView.isHidden = true
        dismissKey()
        uiSetup()
        setupCardTableView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CardDetailsViewController {
            guard let indexPath = cardTableView.indexPathForSelectedRow else {
                return
            }
            let cell = cardTableView.cellForRow(at: indexPath) as! ContactsCell
            let selectedCellImage = cell.avatarImageView.image

            let contact = contacts[indexPath.row]
            CardManager.shared.currentContactDetails = contact
            destination.viewModel = CardDetailsViewModel(contactImage: selectedCellImage)
        }
    }

// MARK: - Actions
    @IBAction func sortButtonPressed(_ sender: Any) {

        let nameAction = UIAlertAction(title: "Name", style: .default) { (_) in
            self.contacts.sort { (current, next) -> Bool in
                return next.name.fullName ?? "" > current.name.fullName ?? ""
            }
            self.sortedBy = .name
            self.cardTableView.reloadData()
        }

        let recentlyAddedAction = UIAlertAction(title: "Recently added", style: .default) { (_) in
            self.contacts.sort(by: {$0.createdAt!.dateValue().compare($1.createdAt!.dateValue()) == .orderedDescending})
            self.sortedBy = .recentlyAdded
            self.cardTableView.reloadData()
            }

        if sortedBy == .recentlyAdded {
            recentlyAddedAction.setValue(K.Images.check, forKey: "image")
            nameAction.setValue(UIImage(), forKey: "image")
        } else {
            nameAction.setValue(K.Images.check, forKey: "image")
            recentlyAddedAction.setValue(UIImage(), forKey: "image")
        }

        let alertController = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = .black

        alertController.addAction(recentlyAddedAction)
        alertController.addAction(nameAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)

    }

    @IBAction func createCardPressed(_ sender: Any) {
        let manager = CardManager.shared
        manager.currentContactType = .createContactCard
        manager.reset()
        addCardBottomSheet.modalPresentationStyle = .custom
        addCardBottomSheet.delegate = self
        addCardBottomSheet.transitioningDelegate = self

        self.present(addCardBottomSheet, animated: true, completion: nil)
    }

// MARK: - Methods
    private func handleError(title: String, error: Error) {
        alert(title: title, message: error.localizedDescription)
    }

    private func setupCardTableView() {
        cardTableView.dataSource = self
        cardTableView.delegate = self
        cardTableView.register(
            UINib(
                nibName: K.contactCell,
                bundle: nil
            ),
            forCellReuseIdentifier: K.contactCellIdentifier
        )
    }

    private func contactsRetrievalSuccessful() {
        self.removeActivityIndicator()
        self.removeActivityIndicator()
        emptyCardsView.isHidden = !viewModel.contactsIsEmpty
        cardTableView.isHidden = viewModel.contactsIsEmpty
        self.contacts = viewModel.contacts
        cardTableView.reloadData()
    }

    private func uiSetup() {
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    private func editContact(indexPath: IndexPath) {
        let contact = self.contacts[indexPath.row]

        viewModel.editContact(contact: contact)
        self.performSegue(withIdentifier: K.Segues.cardsToCreateCard, sender: self)
    }

    private func exportToContact(indexPath: IndexPath) {
        let store = CNContactStore()
        let contact = self.contacts[indexPath.row]
        let image = (cardTableView.cellForRow(at: indexPath) as! ContactsCell).avatarImageView.image
        let phoneContact = viewModel.createCNContact(contact: contact, contactImage: image)
        let contactVc = CNContactViewController(forUnknownContact: phoneContact)
        contactVc.contactStore = store
        contactVc.allowsActions = false
        navigationController?.navigationBar.isHidden = false
        hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(contactVc, animated: true)
        hidesBottomBarWhenPushed = false
    }

    private func deleteContact(indexPath: IndexPath) {
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [self] (_) in
            let contact = contacts[indexPath.row]
            viewModel.deleteCard(contact: contact)
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

// MARK: - TableView
extension CardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: K.contactCellIdentifier,
            for: indexPath) as? ContactsCell
        cell?.selectionStyle = .none

        let contact = contacts[indexPath.row]
        cell?.viewModel = ContactsCellViewModel(contact: contact)
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segues.cardsToCardDetails, sender: self)
    }

    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint)
    -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { _ -> UIMenu? in
            let editAction =
                UIAction(title: NSLocalizedString("Edit", comment: ""),
                         image: K.Images.edit) { _ in
                    self.editContact(indexPath: indexPath)
                }
            let exportAction =
                UIAction(title: NSLocalizedString("Export to Contacts", comment: ""),
                         image: K.Images.contacts) { _ in
                    self.exportToContact(indexPath: indexPath)
                }
            let deleteAction =
                UIAction(title: NSLocalizedString("Delete", comment: ""),
                         image: K.Images.delete,
                         attributes: .destructive) { _ in
                    self.deleteContact(indexPath: indexPath)
                }
            return UIMenu(title: "", children: [editAction, exportAction, deleteAction])
        }
    }
}

// MARK: - UITransitioningDelegate
extension CardViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - BottomSheetDelegate
extension CardViewController: AddCardBottomSheetDelegate {
    func scanPhysicalCardPressed() {
        addCardBottomSheet.dismiss(animated: true)
        self.performSegue(withIdentifier: K.Segues.cardsToCamera, sender: self
        )
    }

    func addManuallyPressed() {
        addCardBottomSheet.dismiss(animated: true)
        self.performSegue(withIdentifier: K.Segues.cardsToCreateCard, sender: self)
    }
}
