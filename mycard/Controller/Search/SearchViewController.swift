//
//  SearchTableViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/5/21.
//

import UIKit

class SearchViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emtpySearchView: UIView!

// MARK: - Properties
    private var contacts: [Contact] {
        return CardManager.shared.createdContactCards
    }
    private var filteredContacts: [Contact] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        let searchBarScopeISFiltering = searchController.searchBar.selectedScopeButtonIndex != 0

        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeISFiltering)
    }

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        emtpySearchView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            UINib(nibName:
                    K.contactCell,
                  bundle: nil),
            forCellReuseIdentifier: K.contactCellIdentifier
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupSearchController()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CardDetailsViewController {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            var contact: Contact
            if isFiltering {
                contact = filteredContacts[indexPath.row]
            } else {
                contact = contacts[indexPath.row]
            }

            let selectedCellImage = (tableView.cellForRow(at: indexPath) as! ContactsCell).avatarImageView.image
            CardManager.shared.currentContactDetails = contact
            destination.viewModel = CardDetailsViewModel(contactImage: selectedCellImage)

        }
    }

// MARK: - Custom Methods
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for card"
        searchController.searchBar.scopeButtonTitles = [
            "All", "Name", "Company", "Role"
        ]
        searchController.searchBar.searchBarStyle = .minimal
        navigationItem.searchController = searchController
        searchController.isActive = true
        searchController.hidesNavigationBarDuringPresentation = true
        let font = UIFont(name: "inter", size: 14)
        searchController.searchBar
            .setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)

        if #available(iOS 13.0, *) {
            let textfield = searchController.searchBar.searchTextField

            textfield.setTextStyle(with: K.TextStyles.bodyBlack)
        }

        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }

    }

    private func filterContentForSearchText(_ searchText: String, category: String? = nil) {
        let category = category?.lowercased()
        let text = searchText.lowercased()

        if !searchText.isEmpty {
            switch category {
            case "name":
                filteredContacts = contacts.filter({ (contact) -> Bool in
                    return contact.name.fullName?.lowercased().contains(text) ?? false
                })
            case "company":
                filteredContacts = contacts.filter({ (contact) -> Bool in
                    return contact.businessInfo?.companyName!.lowercased().contains(text) ?? false
                })
            case "role":
                filteredContacts = contacts.filter({ (contact) -> Bool in
                    return contact.businessInfo?.role?.lowercased().contains(text) ?? false
                })
            default:
                filteredContacts = contacts.filter({ (contact) -> Bool in
                    return contact.name.fullName?.lowercased().contains(text) ?? false ||
                        contact.businessInfo?.companyName?.lowercased().contains(text) ?? false ||
                        contact.businessInfo?.role?.lowercased().contains(text) ?? false
                })
            }
        } else {
            filteredContacts = contacts
        }
        tableView.reloadData()
    }

}

// MARK: - Table view data source
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isFiltering {
          return filteredContacts.count
        }

        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: K.contactCellIdentifier,
            for: indexPath) as? ContactsCell

        cell?.selectionStyle = .none

        var contact: Contact?

        if isFiltering {
            contact = filteredContacts[indexPath.row]
        } else {
            contact = contacts[indexPath.row]
        }
        cell?.viewModel = ContactsCellViewModel(contact: contact!)
        return cell!

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: K.Segues.searchToCardDetails, sender: self)
    }
}

// MARK: - Search bar delegate
extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let category = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchBar.text!, category: category)
        if filteredContacts.isEmpty && !isSearchBarEmpty {
            self.emtpySearchView.isHidden = false
        } else {
            self.emtpySearchView.isHidden = true
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }

}
