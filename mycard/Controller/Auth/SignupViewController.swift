//
//  AuthViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/6/20.
//

import UIKit
import SKCountryPicker

class SignupViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var countryPickerButton: UIButton!
    @IBOutlet weak var navbar: UINavigationBar!

// MARK: - Variables
    private var viewModel = SignupViewModel()
    private var verifyModal: UIView?
    private let contryPickerController = CountryPickerController()
    private var countryCode: String?
    private var phoneNumberText: String?
    var authFlowType: AuthFlowType?

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        self.dismissKey()
        if authFlowType == .changePhoneNumber {
            signupLabel.text = "Change Phone Number"
            signupButton.setTitle("Continue", for: .normal)
        }

        phoneNumberTextField.delegate = self
        signupLabel.style(with: K.TextStyles.heading1)
        phoneNumberTextField.setTextStyle(with: K.TextStyles.bodyBlack40)
        signupButton.setTitle(with: K.TextStyles.buttonWhite, for: .normal)

        let country = CountryManager.shared.currentCountry
        countryImageView.image = country?.flag
        countryCode = country?.dialingCode

        countryImageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(countryImageViewTapped)))
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navbar.shadowImage = UIImage()

    }

    override func viewDidAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
//            self.backButtonTopConstraint.constant = 0
//            self.backButton.alpha = 1
//            self.view.layoutIfNeeded()
//        }
        super.viewDidAppear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? VerifyNumberViewController {
            destinationController.authFlowType = authFlowType ?? .authentication
        }
    }

// MARK: - Actions
    @IBAction func countryButtonPressed(_ sender: Any) {
       showCountryPicker()
    }
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        showVerificationModal()
    }

    @IBAction func backButtonPressed(_ sender: Any) {

//        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
//            self.backButtonTopConstraint.constant = -5
//            self.backButton.alpha = 0
//            self.view.layoutIfNeeded()
//        } completion: {[self] (_) in
////            self.dismiss(animated: false, completion: nil)
//        }
        navigationController?.popViewController(animated: true)
    }

// MARK: - Methods
    private func authenticateUser() {
        self.showActivityIndicator()
        viewModel.bindError = handleErrorFunc
        viewModel.bindSignupViewModelToController = handleSuccess
        viewModel.authenticateUser(with: phoneNumberText ?? "")
    }

    private func handleErrorFunc(title: String, error: Error) {
        self.removeActivityIndicator()
        self.alert(title: title, message: error.localizedDescription)
    }

    private func handleSuccess() {
        self.removeActivityIndicator()
        self.performSegue(withIdentifier: K.Segues.signupToVerifyNumber, sender: self)
    }

    private func showVerificationModal () {
        phoneNumberText = "\(countryCode!)\(phoneNumberTextField.text!.replacingOccurrences(of: " ", with: ""))"

        if phoneNumberText!.isValid(.phoneNumber) {
            verifyModal = UIView()
            verifyModal?.translatesAutoresizingMaskIntoConstraints = false

            self.view.addSubview(verifyModal!)

            verifyModal?.backgroundColor = K.Colors.Black40
            verifyModal?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
            verifyModal?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
            verifyModal?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            verifyModal?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

            let contentView = UIView()
            verifyModal?.addSubview(contentView)

            contentView.heightAnchor.constraint(equalToConstant: 192).isActive = true
            contentView.backgroundColor = K.Colors.White
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
            if authFlowType == .changePhoneNumber {
                promptLabel.attributedText = "Is \(phoneNumberText ?? "") the number you \nwant to change to?"
                    .withBoldText(
                        text: "\(phoneNumberText ?? "")",
                        font: UIFont(name: "Inter",
                                     size: 16))
            } else {
                promptLabel.attributedText = "Is \(phoneNumberText ?? "") the number you \nwant to sign up with?"
                    .withBoldText(
                        text: "\(phoneNumberText ?? "")",
                        font: UIFont(name: "Inter",
                                     size: 16))
            }
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

    private func showCountryPicker() {
        let countryController = CountryPickerWithSectionViewController
            .presentController(on: self) { (country: Country) in
            self.countryImageView.image = country.flag
            self.countryCode = country.dialingCode
        }
        // can customize the countryPicker here e.g font and color
        countryController.detailColor = UIColor.red

    }

    @objc private func countryImageViewTapped(_ notification: NSNotification) {
        showCountryPicker()
    }

    @objc private func onYesButtonTapped(_ notification: NSNotification) {
        verifyModal?.removeFromSuperview()
        authenticateUser()
    }

    @objc private func onNoButtonTapped(_ notification: NSNotification) {
        verifyModal?.removeFromSuperview()
    }
}

// MARK: - Textfield delegate
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
