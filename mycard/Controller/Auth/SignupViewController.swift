//
//  AuthViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/6/20.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    
    @IBOutlet weak var signupLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!

    
    @objc func handleNotification() {
        print("hello world")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()
        customNavigationBar.setup(backIndicatorImage: "xmark")

        signupLabel.style(with: K.TextStyles.heading1)
        phoneNumberTextField.setTextStyle(with: K.TextStyles.bodyBlack40)
        nameTextField.setTextStyle(with: K.TextStyles.bodyBlack40)
        signupButton.setTitle(with: K.TextStyles.buttonWhite, for: .normal)
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        let user = User(name: nameTextField.text, phoneNumber: phoneNumberTextField.text, uid: nil)
        UserAuth.auth.phoneNumberAuth(with: user) { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: K.Segues.signupToVerifyNumber, sender: self)
            }
        }
    }
}
