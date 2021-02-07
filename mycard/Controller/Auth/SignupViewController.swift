//
//  AuthViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/6/20.
//

import UIKit
import SKCountryPicker

class SignupViewController: UIViewController {

    
    @IBOutlet weak var signupLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var countryImageView: UIImageView!
    
    var verifyModal: UIView?
    
    let contryPickerController = CountryPickerController()
    
    var countryCode: String?
    var phoneNumberText: String?
    
    @IBOutlet weak var countryPickerButton: UIButton!
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
        
        let country = CountryManager.shared.currentCountry
        countryImageView.image = country?.flag
        countryCode = country?.dialingCode
        
        countryImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(countryImageViewTapped)))
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
        self.showActivityIndicator()
        let user = User(name: nameTextField.text, phoneNumber: phoneNumberText, uid: nil)
        UserAuthManager.auth.phoneNumberAuth(with: user) { (error) in
            if let error = error {
                self.removeActivityIndicator()
                self.alert(title: "Error authenticating", message: error.localizedDescription)
                
            } else {
                self.performSegue(withIdentifier: K.Segues.signupToVerifyNumber, sender: self)
                self.removeActivityIndicator()
            }
        }
    }
    
    fileprivate func showVerificationModal () {
        
        phoneNumberText = "\(countryCode!)\(phoneNumberTextField.text!.replacingOccurrences(of: " ", with: ""))"
        
        if phoneNumberText!.isValid(.phoneNumber) {
            verifyModal = UIView()
            verifyModal?.translatesAutoresizingMaskIntoConstraints = false
            
            
            self.view.addSubview(verifyModal!)
            
            verifyModal?.backgroundColor = UIColor(named: K.Colors.mcBlack40)
            verifyModal?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
            verifyModal?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
            verifyModal?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            verifyModal?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
            
            let contentView = UIView()
            verifyModal?.addSubview(contentView)
            
            contentView.heightAnchor.constraint(equalToConstant: 192).isActive = true
            contentView.backgroundColor = UIColor(named: K.Colors.mcWhite)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.cornerRadius = 8
            
            contentView.rightAnchor.constraint(equalTo: verifyModal!.rightAnchor, constant: -16).isActive = true
            contentView.leadingAnchor.constraint(equalTo: verifyModal!.leadingAnchor, constant: 16).isActive = true
            contentView.centerYAnchor.constraint(equalTo: verifyModal!.centerYAnchor).isActive = true
            
            let confirmTextLabel = UILabel()
            confirmTextLabel.translatesAutoresizingMaskIntoConstraints = false
            confirmTextLabel.text = "Confirm your number"
            confirmTextLabel.style(with: K.TextStyles.heading3)
            contentView.addSubview(confirmTextLabel)
            confirmTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            confirmTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
            
            let promptLabel = UILabel()
            promptLabel.attributedText = "Is \(phoneNumberText ?? "") the number you \nwant to sign up with?".withBoldText(text: "\(phoneNumberText ?? "")", font: UIFont(name: "Inter", size: 16))
            contentView.addSubview(promptLabel)
            promptLabel.translatesAutoresizingMaskIntoConstraints = false
            promptLabel.numberOfLines = 2
            promptLabel.lineBreakMode = .byWordWrapping
            promptLabel.leadingAnchor.constraint(equalTo: confirmTextLabel.leadingAnchor, constant: 0).isActive = true
            promptLabel.topAnchor.constraint(equalTo: confirmTextLabel.bottomAnchor, constant: 16).isActive = true
            promptLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
            
            let yesButton = UIButton()
            yesButton.setTitle("Yes", for: .normal)
            yesButton.setTitle(with: K.TextStyles.bodyBlue, for: .normal)
            
            
            let noButton = UIButton()
            noButton.setTitle("Go back", for: .normal)
            noButton.setTitle(with: K.TextStyles.bodyBlue, for: .normal)
            
            contentView.addSubview(yesButton)
            contentView.addSubview(noButton)
            
            yesButton.translatesAutoresizingMaskIntoConstraints = false
            yesButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -28).isActive = true
            yesButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28).isActive = true
            
            noButton.translatesAutoresizingMaskIntoConstraints = false
            noButton.rightAnchor.constraint(equalTo: yesButton.leftAnchor, constant: -32).isActive = true
            noButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28).isActive = true
            
            yesButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onYesButtonTapped)))
            noButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onNoButtonTapped)))
            
        } else {
            warningLabel.text = "Please enter a valid phone number"
        }
        
    }
    
    func showCountryPicker() {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            self.countryImageView.image = country.flag
            self.countryCode = country.dialingCode
        }
        // can customize the countryPicker here e.g font and color
        countryController.detailColor = UIColor.red

    }
    
    @objc func countryImageViewTapped(_ notification: NSNotification) {
        showCountryPicker()
    }
    
    
    
    @objc func onYesButtonTapped(_ notification: NSNotification) {
        verifyModal?.removeFromSuperview()
        authenticateUser()
    }
    
    @objc func onNoButtonTapped(_ notification: NSNotification) {
        verifyModal?.removeFromSuperview()
    }
    
    @IBAction func countryButtonPressed(_ sender: Any) {
       showCountryPicker()
    }
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        showVerificationModal()
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
    func textFieldDidChangeSelection(_ textField: UITextField) {
        phoneNumberText = "\(countryCode!)\(phoneNumberTextField.text!)"
        if phoneNumberText!.isValid(.phoneNumber) {
            warningLabel.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        authenticateUser()
        return true
    }
}
