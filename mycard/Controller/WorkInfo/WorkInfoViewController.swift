//
//  WorkInfoViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/20/20.
//

import UIKit

class WorkInfoViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var navigationBar: CustomNavigationBar!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var workInfoSectionLabel: UILabel!
    @IBOutlet weak var workLocationLabel: UILabel!
    @IBOutlet weak var continueButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var workLocationTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var continueButton: UIButton!

// MARK: - Variables
    var viewModel: WorkInfoViewModel!
    private var keyboardHeight: Float?
    private var contact: Contact? {
        return CardManager.shared.currentEditableContact
    }

// MARK: - ViewController methods
    override func viewWillAppear(_ animated: Bool) {
        populateWithContact()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.bindError = handleError
        viewModel.bindSaveSuccessful = saveSuccessful
        viewModel.bindContinue = continueToNextPage
        self.dismissKey()
        keyboardNotificationObservers()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController = segue.destination as! ConfirmDetailsViewController
        destinationController.viewModel = ConfirmDetailsViewModel(contact: contact!)
    }

// MARK: - Actions
    @IBAction func backBarButtonPressed(_ sender: Any) {
        saveCardData()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        saveCardData()
    }

// MARK: - Custom methods
    @objc private func handleKeyboardShow(notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.keyboardHeight = Float(keyboardRectangle.height)
        }
    }

    private func populateWithContact() {
        workLocationTextField.text = viewModel.address
        companyNameTextField.text = viewModel.companyName
        jobTitleTextField.text = viewModel.role
    }

    private func setupUI() {
        navigationBar.shadowImage = UIImage()
        titleLabel.style(with: K.TextStyles.heading1)
        pageCountLabel.style(with: K.TextStyles.subTitle)
        workInfoSectionLabel.style(with: K.TextStyles.subTitle)
        workLocationLabel.style(with: K.TextStyles.subTitle)
        continueButton.setTitle(viewModel.continueButtonTitle, for: .normal)

    }

    private func saveCardData() {
        viewModel.role = jobTitleTextField.text!
        viewModel.companyName = companyNameTextField.text!
        viewModel.address = workLocationTextField.text!
        viewModel.saveCardData()
    }

    private func handleError(error: Error) {
        self.alert(title: "Error saving data", message: error.localizedDescription)
    }

    private func saveSuccessful() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    private func continueToNextPage() {
        performSegue(withIdentifier: K.Segues.workInfoToConfirmDetails, sender: self)
    }

    private func keyboardNotificationObservers() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(handleKeyboardShow(notification:)),
                         name: UIResponder.keyboardDidShowNotification,
                         object: nil)
    }
}

// MARK: - Textfield delegates
extension WorkInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var point = textField.convert(textField.frame.origin, to: self.scrollView)
        point.x = 0.0
        scrollView.setContentOffset(CGPoint(x: 0, y: 160), animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
}
