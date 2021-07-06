//
//  ConfirmDetailsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/21/20.
//

import UIKit
import FirebaseFirestore

class ConfirmDetailsViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var nameInitialsLabel: UILabel!
    @IBOutlet weak var nameInitialsView: UIView!
    @IBOutlet weak var cardJobTitleLabel: UILabel!
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var contactDetailsStackView: ContactDetailsStackView!
    @IBOutlet weak var contactDetailsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var dummyView: UIView!

    // MARK: - Variables
    var viewModel: ConfirmDetailsViewModel!

// MARK: - Viewcontroller methods
    override func viewWillAppear(_ animated: Bool) {
        populateWithContactData()

        if viewModel.noteIsHidden {
            notesView.isHidden = true
            dummyView.topAnchor.constraint(equalTo: contactDetailsStackView.bottomAnchor, constant: 0).isActive = true
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.dismissKey()
        viewModel?.bindError = handleError
        viewModel?.bindSaveSuccessful = saveSuccessful
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NotesViewController {
            vc.presentationController?.delegate = self
            vc.viewModel = NotesViewModel()
        }
    }

// MARK: - Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveCardButtonPressed(_ sender: Any) {
        DispatchQueue.main.async(execute: DispatchWorkItem(block: {
            self.showActivityIndicator()
        }))
        viewModel?.saveCard()
    }

// MARK: - Methods
    private func setupUI() {
        createButton.setTitle(viewModel?.saveButtonTitle, for: .normal)
        noteLabel.style(with: K.TextStyles.captionBlack60)
        contactDetailsStackViewHeightConstraint.isActive = false
        customNavigationBar.shadowImage = UIImage()
        let randomColor = UIColor.random
        nameInitialsView.backgroundColor = randomColor
        nameInitialsView.alpha = 0.1
        nameInitialsLabel.textColor = randomColor
        cardJobTitleLabel.style(with: K.TextStyles.subTitle)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(notesViewTapped))
        notesView.addGestureRecognizer(gestureRecognizer)

    }

    private func handleError(error: Error) {
        removeActivityIndicator()
        alert(title: "Oops", message: error.localizedDescription)
    }

    private func saveSuccessful() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    private func firstCardSaveSuccessful() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let profileSetupViewController = storyboard.instantiateViewController(
            identifier: K.ViewIdentifiers.profileSetupViewController
        ) as ProfileSetupViewController
        UIApplication.shared.windows.first?.rootViewController = profileSetupViewController
    }

    @objc private func notesViewTapped() {
        performSegue(withIdentifier: K.Segues.confirmDetailsToNotes, sender: self)
    }

    private func populateWithContactData() {
        contactDetailsStackView.configure(contact: viewModel?.contact)
        cardNameLabel.text = viewModel?.fullName
        cardJobTitleLabel.text = viewModel?.role
        nameInitialsLabel.text = viewModel?.nameInitials
        noteTextLabel.text = viewModel?.note
        noteTextLabel.textColor = viewModel?.noteTextColor
    }
}

extension ConfirmDetailsViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewWillAppear(true)
    }
}
