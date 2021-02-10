//
//  CardViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/7/20.
//

import UIKit

class CardViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchStackView: UIStackView!
    
    @IBOutlet weak var searchStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var searchTextLabel: UILabel!
    
    @IBOutlet weak var emptyCardsView: UIView!
    @IBOutlet weak var floatiingButtonConstraints: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var aView: UIView?
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
    }
    
    var contacts: [Contact] = []
    var filteredContacts: [Contact] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering =
          searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive &&
          (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }

    fileprivate func setupSearchController() {
        //        set up searchcontroller
        searchController.searchBar.alpha = 1
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for card"
        searchController.searchBar.scopeButtonTitles = [
            "All", "Name", "Company", "Role"
        ]
        searchController.searchBar.showsScopeBar = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.setScopeBarButtonBackgroundImage(UIImage(named: "scope button selected"), for: .selected)
        definesPresentationContext = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showCardLoadingIndicator()
        FirestoreService().getAllContacts(uid: AuthService.uid) { (error, contacts) in
            if let error = error {
                self.removeCardLoadingIndicator()
                self.alert(title: "Unable to load cards", message: error.localizedDescription)
            }
            self.removeCardLoadingIndicator()
            self.contacts = contacts ?? []
            if contacts == nil || contacts?.isEmpty == true {
                self.emptyCardsView.isHidden = false
            } else {
                self.emptyCardsView.isHidden = true
            }

            DispatchQueue.main.async {
                self.cardTableView.reloadData()
            }
        }
        self.dismissKey()
        uiSetup()
        cardTableView.dataSource = self
        cardTableView.delegate = self
//
        cardTableView.register(UINib(nibName: K.contactCell, bundle: nil), forCellReuseIdentifier: K.contactCellIdentifier)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSearchFieldTapped))
        searchTextLabel.addGestureRecognizer(gestureRecognizer)

    }
    
    func showCardLoadingIndicator() {
//        loadingIndicator.startAnimating()
//        loadingIndicator.isHidden = false
        
    }
    
    func removeCardLoadingIndicator() -> Void {
//        loadingIndicator.stopAnimating()
//        loadingIndicator.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(keyboardShowNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(keyboardHideNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleSearchFieldTapped() {
        setupSearchController()
        let textfield = searchController.searchBar.searchTextField
        navigationItem.searchController = searchController
        searchController.isActive = true
        searchController.hidesNavigationBarDuringPresentation = true
        navigationController?.navigationBar.backgroundColor = .white
        DispatchQueue.main.async {
            let font = UIFont(name: "inter", size: 16)

            textfield.backgroundColor = .clear
            textfield.font = font
            
            self.searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.font : font!], for: .normal)
            self.searchController.searchBar.setShowsScope(true, animated: true)
            self.searchController.isActive = true

            self.searchController.searchBar.borderColor = .red
            self.searchController.searchBar.searchBarStyle = .minimal
            self.searchController.searchBar.showsScopeBar = true

                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    self.searchStackViewTopConstraint.constant = -48
                    self.searchStackView.alpha = 0
                    self.view.layoutIfNeeded()
                    self.searchController.searchBar.becomeFirstResponder()
                    self.searchController.isActive = true
                }

        }
    }
    
    
    func uiSetup() {
        navigationController?.navigationBar.shadowImage = UIImage()
        let label = UILabel()
        label.style(with: K.TextStyles.heading1)
        label.text = "Cards";
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CardDetailsViewController {
            destination.contact = contacts[(cardTableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    func filterContentForSearcn(_ searchText: String, category: String?) {

        if let category = category {
            switch category.lowercased() {
            case "name":
                filteredContacts = contacts.filter({ (contact: Contact) -> Bool in
                    return (contact.name.fullName?.lowercased().contains(searchText.lowercased()))!
                })
            case "company":
                filteredContacts = contacts.filter({ (contact: Contact) -> Bool in
                    return (contact.businessInfo.companyName.lowercased().contains(searchText.lowercased()))
                })
            case "role":
                filteredContacts = contacts.filter({ (contact) -> Bool in
                    return contact.businessInfo.role.lowercased().contains(searchText.lowercased())
                })
            default:
                filteredContacts = contacts.filter({ (contact) -> Bool in
                    return contact.businessInfo.role.lowercased().contains(searchText.lowercased()) ||
                        (contact.businessInfo.companyName.lowercased().contains(searchText.lowercased())) ||
                        (contact.name.fullName?.lowercased().contains(searchText.lowercased()))!
                    
                })
            }
        } else {
            filteredContacts = contacts.filter({ (contact) -> Bool in
                return contact.businessInfo.role.lowercased().contains(searchText.lowercased()) ||
                    (contact.businessInfo.companyName.lowercased().contains(searchText.lowercased())) ||
                    (contact.name.fullName?.lowercased().contains(searchText.lowercased()))!
                
            })

        }
        
        cardTableView.reloadData()
        
    }
}

//MARK: - OBJC functions
extension CardViewController {
    @objc
    func handleKeyboard(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            DispatchQueue.main.async {
                
                self.floatiingButtonConstraints.constant = keyboardRectangle.height - 30
                UIView.animate(withDuration: 0.1) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc
    func handleKeyboard(keyboardHideNotification notification:Notification) {
        DispatchQueue.main.async {
            self.floatiingButtonConstraints.constant = 24
        }
    }
}

//MARK: - Tableview Datasource and delegate
extension CardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredContacts.count
        }
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.contactCellIdentifier, for: indexPath) as! ContactsCell
        cell.selectionStyle = .none
        let contact: Contact
        if isFiltering {
            contact = filteredContacts[indexPath.row]
        } else {
            contact = contacts[indexPath.row]
        }
        cell.contact = contact
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .moveIn
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        performSegue(withIdentifier: K.Segues.cardsToCardDetails, sender: self)
    }
}


extension CardViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let selectedScopeIndex = searchBar.selectedScopeButtonIndex
        filterContentForSearcn(searchBar.text!, category: searchBar.scopeButtonTitles![selectedScopeIndex])
    }
}

extension CardViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
//        self.searchController.searchBar.becomeFirstResponder()
    }
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationItem.searchController = nil

    }
    func didDismissSearchController(_ searchController: UISearchController) {
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.searchStackViewTopConstraint.constant = 8
                self.searchStackView.alpha = 1
            }
        }

    }
}

extension CardViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2) {
            self.navigationItem.searchController?.searchBar.alpha = 0
        } completion: { (isComplete) in
            self.searchController.dismiss(animated: true) {
            }
        }


    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearcn(searchBar.text!, category: searchBar.scopeButtonTitles![selectedScope])
    }
}
