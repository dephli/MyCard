//
//  CardViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/7/20.
//

import UIKit

class CardViewController: UIViewController {
    enum SortBy {
        case recentlyAdded
        case name
    }

// MARK: - Outlets
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var emptyCardsView: UIView!
    @IBOutlet weak var floatiingButtonConstraints: NSLayoutConstraint!

// MARK: - Variables
    private var aView: UIView?
    private var contacts: [Contact] = []
    private var sortedBy: SortBy = .recentlyAdded

// MARK: - ViewController methods
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
        self.showActivityIndicator()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        cardTableView.isHidden = true
        emptyCardsView.isHidden = true
        getAllContacts()
        self.dismissKey()
        uiSetup()
        setupCardTableView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CardDetailsViewController {
            guard let indexPath = cardTableView.indexPathForSelectedRow else {
                return
            }
            let cell = cardTableView.cellForRow(at: indexPath) as! ContactsCell
            if let image = cell.avatarImageView.image {
                destination.contactImage = image
            }
            destination.contact = contacts[indexPath.row]
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
        manager.setContactType(type: .createContactCard)
        manager.reset()

        self.performSegue(withIdentifier: K.Segues.cardsToCreateCard, sender: self)
    }

// MARK: - Methods
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

    private func getAllContacts() {
        guard let uid = AuthService.uid else {
            self.alert(title: "Error", message: "Inactive user. login again")
            return
        }
        FirestoreService.manager.getAllContacts(uid: uid) { (error) in
            self.removeActivityIndicator()
            if let error = error {
                self.alert(title: "Unable to load cards", message: error.localizedDescription)
            }
            let contacts = CardManager.shared.createdContactCards
            self.contacts = contacts
            if contacts.isEmpty == true {
                self.emptyCardsView.isHidden = false
                self.cardTableView.isHidden = true
            } else {
                self.emptyCardsView.isHidden = true
                self.cardTableView.isHidden = false
            }

            DispatchQueue.main.async {
                self.cardTableView.reloadData()
            }
        }
    }

    private func uiSetup() {
        navigationController?.navigationBar.shadowImage = UIImage()
        let label = UILabel()
        label.style(with: K.TextStyles.heading1)
        label.text = "My Network"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)

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

        cell?.contact = contacts[indexPath.row]
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segues.cardsToCardDetails, sender: self)
    }
}
