//
//  PersonalInfoViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/9/20.
//

import UIKit

class PersonalInfoViewController: UIViewController {
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var prefixTextField: UITextField!
    
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var nameStackView: UIStackView!
    
    @IBOutlet weak var phoneNumbersStackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneNumbersStackView: PhoneListStackView!
    @IBOutlet weak var customNavBar: CustomNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKey()
        
        uiSetup()
        
        nameSetup()
        
        phoneNumbersStackViewHeightConstraint.isActive = false
        
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewPhonePressed(_ sender: Any) {
        PhoneNumberManager.numbers.append(with: PhoneNumber(type: "Home", number: ""))
    }
}


//MARK: - UI Setup
extension PersonalInfoViewController {
    func uiSetup() {
        phoneNumbersStackView.configure()
        customNavBar.setup(backIndicatorImage: "xmark")
        personalInfoLabel.style(with: K.TextStyles.heading1)
        pageCountLabel.style(with: K.TextStyles.subTitle)
//        emailLabel.style(with: K.TextStyles.subTitle)
        
        titleLabel.style(with: K.TextStyles.captionBlack60)
        phoneTitleLabel.style(with: K.TextStyles.captionBlack60)
    }
}


//MARK: - Name Setup
extension PersonalInfoViewController {
    func nameSetup() {
        
        let stackViewLength = nameStackView.arrangedSubviews.count
        for i in 1...stackViewLength - 2 {
            nameStackView.arrangedSubviews[stackViewLength - i].isHidden = true
        }

        nameStackView.arrangedSubviews[1].isHidden = false
    }
    
    @IBAction func bottomCaretButtonPressed(_ sender: UIButton) {

        let stackViewLength = nameStackView.arrangedSubviews.count
        nameStackView.arrangedSubviews[1].isHidden.toggle()
        
        DispatchQueue.main.async {
            for i in 1...stackViewLength - 2 {
                self.nameStackView.arrangedSubviews[stackViewLength - i].isHidden.toggle()
            }
            
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
