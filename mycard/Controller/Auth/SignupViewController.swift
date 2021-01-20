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
    
    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()

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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("hello")
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
