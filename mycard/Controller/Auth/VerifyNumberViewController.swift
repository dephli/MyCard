//
//  VerifyNumberViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/6/20.
//

import UIKit

class VerifyNumberViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var verifyNumberLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var codeTextField: OneTimeTextField!
    @IBOutlet weak var verifyPhoneNumberButton: UIButton!
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!

// MARK: - Properties
    let viewModel = VerifyNumberViewModel()
    var authFlowType: AuthFlowType?
    private var verifyModal: UIView?

// MARK: - ViewController methods
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()
        viewModel.bindError = handleError
        viewModel.bindSuccess = handleSuccess
        viewModel.bindVerifyPreNumberChange = verifyPhoneNumberForPreNumberChange
        viewModel.bindVerifyRegularAuth = verifyPhoneNumberForRegularAuth
        viewModel.bindVerifyPreNumberChange = verifyPhoneNumberForPreNumberChange

        uiSetup()
        codeTextField.becomeFirstResponder()
        codeTextField.delegate = self
        self.verifyPhoneNumberButton.isEnabled = false

        if authFlowType == .confirmPhoneNumber {
            verifyNumberLabel.text = "Verify that it's you"
        }
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.keyboardDidShow),
                name: OneTimeTextField.textDidChangeNotification,
                object: codeTextField
            )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as? SignupViewController
        viewController?.authFlowType = .changePhoneNumber
    }

// MARK: - Actions
    @IBAction func resendCode(_ sender: Any) {
        self.showActivityIndicator()
        viewModel.resendCode()
    }

    @IBAction func onBackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func verifyButtonPressed(_ sender: Any) {
        self.showActivityIndicator()
        let code = codeTextField.text!
        viewModel.submitCode(with: code, type: authFlowType!)
    }

// MARK: - Methods
    private func handleError(title: String, error: Error) {
        self.removeActivityIndicator()
        self.alert(title: title, message: error.localizedDescription)
    }

    private func handleSuccess() {
        self.removeActivityIndicator()
    }

    @objc private func keyboardDidShow(notifcation: NSNotification) {
        if codeTextField.text?.count == 6 {
            verifyPhoneNumberButton.isEnabled = true
            verifyButtonPressed(verifyPhoneNumberButton!)

        } else {
            verifyPhoneNumberButton.isEnabled = false
        }
    }

    private func verifyPhoneNumberForRegularAuth() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.removeActivityIndicator()
        }

        let username = AuthService.username
        if username != nil
            && username?.trimmingCharacters(in: .whitespaces) != "" {
            self.setRootViewController()
        } else {
            self.performSegue(withIdentifier: K.Segues.verifyNumberToSetupCard, sender: self)
        }

    }

    private func verifyPhoneNumberForPreNumberChange() {
        self.removeActivityIndicator()
        self.performSegue(withIdentifier: K.Segues.verifyPhoneNumberToSignup, sender: self)
    }

    private func verifyNumberForNumberChange() {
        self.removeActivityIndicator()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    private func setRootViewController() {
        let storyboard = UIStoryboard(name: "Cards", bundle: nil)
        if #available(iOS 13.0, *) {
            let tabController = storyboard.instantiateViewController(
                identifier: K.ViewIdentifiers.cardsTabBarController
            ) as TabBarController
            UIApplication.shared.windows.first?.rootViewController = tabController
        } else {
            // Fallback on earlier versions
            let tabController = storyboard.instantiateViewController(
                withIdentifier: K.ViewIdentifiers.cardsTabBarController
            ) as! TabBarController
            UIApplication.shared.windows.first?.rootViewController = tabController
        }

        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    private func uiSetup() {
        customNavigationBar.setup(backIndicatorImage: "arrow.forward")
        codeTextField.configure()
        verifyNumberLabel.style(with: K.TextStyles.heading1)
        promptLabel.style(with: K.TextStyles.bodyBlack5)
        promptLabel.text = "Enter the one-time pin that was sent to your \nnumber"
    }
}

// MARK: - Textfield delegate
extension VerifyNumberViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if codeTextField.text!.trimmingCharacters(in: .whitespaces).count == 6 {
            verifyPhoneNumberButton.isEnabled = true
        } else {
            verifyPhoneNumberButton.isEnabled = false
        }
    }
}
