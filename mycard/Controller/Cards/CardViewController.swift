//
//  CardViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/7/20.
//

import UIKit

class CardViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var floatiingButtonConstraints: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
    }
    
    var contacts: [Contact] = [
        Contact(name: "Mr. John Agyekum", image: "BingWallpaper", occupation: "UI Designer", organization: "Qodehub"),
        Contact(name: "Mr. Kwame Ofori", image: "", occupation: "CEO", organization: "Frimps Oil"),
        Contact(name: "Ms. Aaliyah Ansah", image: "BingWallpaper", occupation: "Lawyer", organization: "Peason Specter"),
        Contact(name: "Dr. Charles Boyle", image: "", occupation: "Surgeon", organization: "Seattle Grace Hospital"),
        Contact(name: "Mr. Jake Peralta", image: "", occupation: "Sargeant", organization: "Brooklyn 99th Precinct"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()
        uiSetup()
        cardTableView.dataSource = self
        
        cardTableView.register(UINib(nibName: K.contactCell, bundle: nil), forCellReuseIdentifier: K.contactCellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(keyboardShowNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(keyboardHideNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
}

extension CardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.contactCellIdentifier, for: indexPath) as! ContactsCell
        let contact = contacts[indexPath.row]
        cell.nameLabel.text = contact.name
        cell.descriptionLabel.text = contact.occupation
        cell.organizationLabel.text = contact.organization
        
        return cell
    }
}

extension CardViewController: UITableViewDelegate {
    
}
