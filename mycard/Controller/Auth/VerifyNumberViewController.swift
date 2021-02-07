//
//  VerifyNumberViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/6/20.
//

import UIKit

class VerifyNumberViewController: UIViewController {

    @IBOutlet weak var verifyNumberLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var codeTextField: OneTimeTextField!
    @IBOutlet weak var verifyPhoneNumberButton: UIButton!
    
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    
    var verifyModal: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()
        uiSetup()
        codeTextField.becomeFirstResponder()
        codeTextField.delegate = self
        self.verifyPhoneNumberButton.isEnabled = false
        
        NotificationCenter.default.addObserver( self,selector:#selector(self.keyboardDidShow), name: OneTimeTextField.textDidChangeNotification, object: codeTextField)
    }
    

    
    @objc func keyboardDidShow(notifcation: NSNotification) {
     if codeTextField.text?.count == 6 {
        verifyPhoneNumberButton.isEnabled = true
        verifyButtonPressed(verifyPhoneNumberButton!)
        
     } else {
        verifyPhoneNumberButton.isEnabled = false
        
     }
        
    }

    @IBAction func resendCode(_ sender: Any) {
        self.showActivityIndicator()
        UserAuthManager.auth.resendtoken { (error) in
            if let error = error {
                self.removeActivityIndicator()
                self.alert(title: "Error", message: error.localizedDescription)
            }
            self.removeActivityIndicator()
        }
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func verifyButtonPressed(_ sender: Any) {
        self.showActivityIndicator()
        let code = codeTextField.text!
        UserAuthManager.auth.submitCode(with: code) { (error) in
            if let error = error {
                self.removeActivityIndicator()
                self.alert(title: "Error authenticating", message: error.localizedDescription)
            } else {
                self.removeActivityIndicator()
                self.setRootViewController()
                self.performSegue(withIdentifier: K.Segues.verifyNumberToCards, sender: self)
            }
        }
    }
    
    fileprivate func setRootViewController() {
        let storyboard = UIStoryboard(name: "Cards", bundle: nil)
        let tabController = storyboard.instantiateViewController(identifier: K.ViewIdentifiers.cardsTabBarController) as TabBarController
        UIApplication.shared.windows.first?.rootViewController = tabController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    
    func uiSetup() {
        customNavigationBar.setup(backIndicatorImage: "arrow.forward")
        codeTextField.configure()
        verifyNumberLabel.style(with: K.TextStyles.heading1)
        promptLabel.style(with: K.TextStyles.bodyBlack5)
        promptLabel.text = "Enter the one-time pin that was sent to your \nnumber"
    }
}


extension VerifyNumberViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if codeTextField.text!.trimmingCharacters(in: .whitespaces).count == 6 {
            verifyPhoneNumberButton.isEnabled = true
        } else {
            verifyPhoneNumberButton.isEnabled = false
        }
    }
}
