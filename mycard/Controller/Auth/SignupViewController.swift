//
//  AuthViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/6/20.
//

import UIKit

class SignupViewController: UIViewController {

    
    @IBOutlet weak var signupLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()
        
        nameTextField.becomeFirstResponder()
        phoneNumberTextField.delegate = self
        signupLabel.style(with: K.TextStyles.heading1)
        phoneNumberTextField.setTextStyle(with: K.TextStyles.bodyBlack40)
        nameTextField.setTextStyle(with: K.TextStyles.bodyBlack40)
        signupButton.setTitle(with: K.TextStyles.buttonWhite, for: .normal)
        backButtonTopConstraint.constant = -5

    }

    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
            self.backButtonTopConstraint.constant = 0
            self.backButton.alpha = 1
            self.view.layoutIfNeeded()
        }
        super.viewDidAppear(animated)

    }

    
    fileprivate func authenticateUser() {
        if phoneNumberTextField.text!.trimmingCharacters(in: .whitespaces).isValid(.phoneNumber) {
            let user = User(name: nameTextField.text, phoneNumber: phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces), uid: nil)
            UserAuthManager.auth.phoneNumberAuth(with: user) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: K.Segues.signupToVerifyNumber, sender: self)
                }
            }
        } else {
            warningLabel.text = "Please enter a valid phone number"
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        authenticateUser()
    }
    @IBAction func backButtonPressed(_ sender: Any) {

        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
            self.backButtonTopConstraint.constant = -5
            self.backButton.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { (true) in
            self.dismiss(animated: false, completion: nil)
        }

        
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        authenticateUser()
        return true
    }
}
