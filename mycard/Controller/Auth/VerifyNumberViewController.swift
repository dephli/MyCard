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
    
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
    }
    

    
    @IBAction func onBackButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func verifyButtonPressed(_ sender: Any) {
        let code = codeTextField.text!
        UserAuthManager.auth.submitCode(with: code) { (error) in
            if let error = error {
                print(error)
            }
            
            self.setRootViewController()
            self.performSegue(withIdentifier: K.Segues.verifyNumberToCards, sender: self)
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

