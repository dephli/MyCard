//
//  ChangeNameViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/19/21.
//

import UIKit

class ChangeNameViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.style(with: K.TextStyles.heading1)
        self.dismissKey()
    }

// MARK: - Actions
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.showActivityIndicator()
        if nameTextField.text?.trimmingCharacters(in: .letters) != "" {
            UserManager.auth.updateUser(with: User(name: nameTextField.text)) { (error) in
                self.removeActivityIndicator()
                if let error = error {
                    self.alert(title: "User Update Failed", message: error.localizedDescription)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
