//
//  ChangePhoneNumberViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/18/21.
//

import UIKit

class ChangePhoneNumberViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!

// MARK: - Viewcontroller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.style(with: K.TextStyles.heading1)
        titleLabel.textAlignment = .center
        subtitleLabel.style(with: K.TextStyles.subTitle)
        phoneNumberLabel.text = AuthService.phoneNumber
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as? VerifyNumberViewController
        viewController?.authFlowType = .confirmPhoneNumber
    }

// MARK: - Actions
    @IBAction func nextButtonPressed(_ sender: Any) {
        self.showActivityIndicator()
        guard let phoneNumber = AuthService.phoneNumber else {
            self.removeActivityIndicator()
            self.alert(title: "Authentication Failed", message: "Please logout and login again")
            return
        }
        UserManager.auth.phoneNumberAuth(with: phoneNumber) { error in
            self.removeActivityIndicator()
            if let error = error {
                self.alert(title: "Authentication Failed", message: error.localizedDescription)
            } else {

                self.performSegue(withIdentifier: K.Segues.settingsToVerifyPhoneNumber, sender: self)
            }
        }
    }
}
