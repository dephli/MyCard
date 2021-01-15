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
    @IBOutlet weak var searchStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var floatiingButtonConstraints: NSLayoutConstraint!
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
    }
    
    var contacts: [Contact] = [
//        Contact(name: "Mr. John Agyekum", image: "BingWallpaper", occupation: "UI Designer", organization: "Qodehub"),
//        Contact(name: "Mr. Kwame Ofori", image: "", occupation: "CEO", organization: "Frimps Oil"),
//        Contact(name: "Ms. Aaliyah Ansah", image: "BingWallpaper", occupation: "Lawyer", organization: "Peason Specter"),
//        Contact(name: "Dr. Charles Boyle", image: "", occupation: "Surgeon", organization: "Seattle Grace Hospital"),
//        Contact(name: "Mr. Jake Peralta", image: "", occupation: "Sargeant", organization: "Brooklyn 99th Precinct"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()
        uiSetup()
        cardTableView.dataSource = self
        cardTableView.delegate = self
        
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
//
//        searchController.searchBar.scopeBarBackgroundImage = UIImage(named: "scope bar background")
        

        cardTableView.register(UINib(nibName: K.contactCell, bundle: nil), forCellReuseIdentifier: K.contactCellIdentifier)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSearchFieldTapped))
        searchView.addGestureRecognizer(gestureRecognizer)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(keyboardShowNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(keyboardHideNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleSearchFieldTapped() {
        let textfield = searchController.searchBar.searchTextField
        navigationItem.searchController = searchController
        searchController.isActive = true
        searchController.hidesNavigationBarDuringPresentation = true
        navigationController?.navigationBar.backgroundColor = .white
        DispatchQueue.main.async {
            let font = UIFont(name: "inter", size: 16)

            textfield.backgroundColor = .clear
            textfield.font = font
            textfield.heightAnchor.constraint(equalToConstant: 48).isActive = true
            
            self.searchController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedString.Key.font : font!], for: .normal)
            self.searchController.searchBar.heightAnchor.constraint(equalToConstant: 48).isActive = true
            self.searchController.searchBar.setShowsScope(true, animated: true)
            self.searchController.searchBar.becomeFirstResponder()
            self.searchController.searchBar.borderColor = .red
            self.searchController.searchBar.searchBarStyle = .minimal
            self.searchStackView.isHidden = true
            self.searchStackViewHeightConstraint.constant = 0
            self.searchController.searchBar.showsScopeBar = true

        }
    }
    
    
    
    @objc
    func handleKeyboard(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            DispatchQueue.main.async {
                print(keyboardRectangle.height)
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
}

extension CardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.contactCellIdentifier, for: indexPath) as! ContactsCell
        cell.selectionStyle = .none
        let contact = contacts[indexPath.row]
        cell.nameLabel.text = contact.fullName
        cell.descriptionLabel.text = contact.occupation
        cell.organizationLabel.text = contact.organization
        
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
        
    }
}

extension CardViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        print("hello world")
    }
}

extension CardViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        UIView.animate(withDuration: 3) {
            searchBar.showsScopeBar = false
            self.searchStackView.isHidden = false
            self.searchStackViewHeightConstraint.constant = 48
        navigationItem.searchController = nil
//        }
    }
}
