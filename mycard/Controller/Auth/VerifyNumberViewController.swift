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
        UserAuth.auth.submitCode(with: code) { (error) in
            if let error = error {
                print(error)
            }
            
            self.performSegue(withIdentifier: K.Segues.verifyNumberToCards, sender: self)
        }
    }

    
    func uiSetup() {
        customNavigationBar.setup(backIndicatorImage: "arrow.forward")
        codeTextField.configure()
        verifyNumberLabel.style(with: K.TextStyles.heading1)
        promptLabel.style(with: K.TextStyles.bodyBlack5)
        promptLabel.text = "Enter the one-time pin that was sent to your \nnumber"
    }
}

