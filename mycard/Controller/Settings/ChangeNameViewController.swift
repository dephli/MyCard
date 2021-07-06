//
//  ChangeNameViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/19/21.
//

import UIKit
import NotificationToast

class ChangeNameViewController: UIViewController {

// MARK: - Outlets
//    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Name"
        self.dismissKey()
        nameTextField.text = AuthService.username
    }

// MARK: - Actions
    @IBAction func saveButtonPressed(_ sender: Any) {
        if nameTextField.text?.trimmingCharacters(in: .letters) != "" {
            self.showActivityIndicator()
            UserManager.auth.updateUser(with: User(name: nameTextField.text)) { (error) in
                self.removeActivityIndicator()
                if let error = error {
                    self.alert(title: "User Update Failed", message: error.localizedDescription)
                } else {
                    let toast = ToastView(
                        title: "Saved!",
                        titleFont: UIFont(name: "inter", size: 16)!,
                        iconSpacing: 16
                    )
                    toast.show()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            self.alert(title: "Error", message: "Name cannot be blank")
        }
    }
}
