//
//  ReviewScannedCardDetailsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 5/1/21.
//

import UIKit
import RxCocoa
import RxSwift
import NotificationToast

class ReviewScannedCardDetailsViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var labelledDetailsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var unlabelledDetailsStackViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var emptyLabelledDetailsView: UIView!
    @IBOutlet weak var emptyUnlabelledDetailsView: UIView!
    @IBOutlet weak var labelledDetailsStackView: LabelledScannedDetailsStackView!
    @IBOutlet weak var unlabelledDetailStackView: UnlabelledScannedDetailsStackView!
    @IBOutlet weak var createCardButton: UIButton!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var assignLabelActionLabel: UILabel!
    @IBOutlet weak var unlabelledStackViewTopConstraint: NSLayoutConstraint!
    // MARK: - Variables

    var viewModel: ReviewScannedCardDetailsViewModel!
    var disposeBag = DisposeBag()
    var currentUnlabelledIndex: Int?
    var selectedDetailToChange: (name: String, index: Int)?
    var selectedDetailToEdit: (name: String, index: Int)?
    var selectedIndexToEdit: Int?
    var detailEditType: EditDetailViewController.DetailEditType?

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        labelledDetailsStackView.delegate = self
        unlabelledDetailStackView.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(notesViewTapped))
        notesView.addGestureRecognizer(gestureRecognizer)
        viewModel.bindError = handleError
        viewModel.bindSaveContactSuccessful = contactSaveSuccessful
        viewModel.bindSaveFirstPersonalContactSuccessful = firstContactSaveSuccessful
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Review scanned details"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
        labelledDetailsStackViewHeightConstraint?.isActive = false
        unlabelledDetailsStackViewHeightConstraint?.isActive = false
        notesView.isHidden = viewModel.noteIsHidden
        let labelledHeightConstraint = labelledDetailsStackView.heightAnchor.constraint(equalToConstant: 138)
        let unlabelledHeightConstraint = unlabelledDetailStackView.heightAnchor.constraint(equalToConstant: 138)
        CardManager.shared.contact.subscribe { [unowned self] contact in
            let labelledContact = contact.element
            labelledDetailsStackView.configure(labelledContact!)
            if labelledDetailsStackView.subviews.isEmpty {
                labelledHeightConstraint.isActive = true
                self.emptyLabelledDetailsView.isHidden = false
            } else {
                labelledHeightConstraint.isActive = false
                self.emptyLabelledDetailsView.isHidden = true
            }
            noteLabel.text = labelledContact?.note ?? "Add a note"
            if labelledContact?.note?.isEmpty ?? true {
                noteLabel.textColor = K.Colors.Blue
            } else {
                noteLabel.textColor = K.Colors.Black
            }

        }.disposed(by: disposeBag)

        viewModel.unlabelledScannedDetails.subscribe { [unowned self] details in

            let unlabelledDetails = details.element
            if unlabelledDetails!.isEmpty {
                unlabelledHeightConstraint.isActive = true
                emptyUnlabelledDetailsView.isHidden = false
                assignLabelActionLabel.isHidden = true
                self.unlabelledStackViewTopConstraint.constant = 0
            } else {
                unlabelledHeightConstraint.isActive = false
                unlabelledDetailStackView.configure(details: unlabelledDetails!)
                emptyUnlabelledDetailsView.isHidden = true
                assignLabelActionLabel.isHidden = false
                self.unlabelledStackViewTopConstraint.constant = 16
            }
        }.disposed(by: disposeBag)
    }

// MARK: - Actions

    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func createCardPressed(_ sender: Any) {
        if viewModel.labelledContact.name.fullName == nil {
            self.alert(title: "Please enter a name", message: "Cannot create a card without a name")
        } else {
            viewModel.createContactCard()
        }
    }

    // MARK: - Custom methods
    @objc private func notesViewTapped() {
        performSegue(withIdentifier: K.Segues.assignLabelToNotes, sender: self)
    }

    private func handleError(error: Error) {
        self.alert(title: "Error", message: error.localizedDescription)
    }

    private func contactSaveSuccessful() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }

    private func firstContactSaveSuccessful() {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        let profileSetupViewController = storyboard.instantiateViewController(
            identifier: K.ViewIdentifiers.profileSetupViewController
        ) as ProfileSetupViewController
        UIApplication.shared.windows.first?.rootViewController = profileSetupViewController
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AssignLabelToScannedDetailsViewController {
            destination.viewModel = viewModel
            guard let detail = selectedDetailToChange else {return}
            destination.detailToChange = detail
            self.selectedDetailToChange = nil

        } else if let destination = segue.destination as? SelectLabelViewController {
            destination.viewmodel = viewModel

        } else if let destination = segue.destination as? EditDetailViewController {
            destination.viewmodel = viewModel
            destination.selectedDetailToEdit = self.selectedDetailToEdit
            destination.selectedIndexToEdit = self.selectedIndexToEdit
            destination.editType = self.detailEditType

        } else if let destination = segue.destination as? NotesViewController {
            destination.viewModel = NotesViewModel()
        }
    }
}

extension ReviewScannedCardDetailsViewController: LabelledScannedDetailsDelegate {
    func untag(detail: (String, Int)) {
        viewModel.untagLabelledDetail(name: detail.0, index: detail.1)
    }

    func edit(detail: (String, Int)) {
        selectedDetailToEdit = detail
        detailEditType = .labelled
        performSegue(withIdentifier: K.Segues.reviewScannedDetailsToEditDetail, sender: self)
    }

    func swap(detail: (String, Int)) {
        self.selectedDetailToChange = detail
        performSegue(withIdentifier: K.Segues.reviewScannedDetailsToAssignLabel, sender: self)
    }

}

extension ReviewScannedCardDetailsViewController: UnlabelledScannedDetailsDelegate {
    func labelPressed(id: Int) {
        selectedIndexToEdit = id
        detailEditType = .unlabelled
        performSegue(withIdentifier: K.Segues.reviewScannedDetailsToEditDetail, sender: self)
    }

    func addLabel(id: Int) {
        viewModel.currentUnlabelledDetailIndex = id
        performSegue(withIdentifier: K.Segues.reviewScannedDetailsToAssignLabel, sender: self)
    }

    func duplicate(id: Int) {
        viewModel.duplicateDetail(at: id)
        let toast = ToastView(
            title: "Copied!",
            titleFont: UIFont(name: "inter", size: 16)!,
            icon: K.Images.copy,
            iconSpacing: 16
        )
        toast.show()
    }

    func remove(id: Int) {
        viewModel.deleteUnlabelledDetail(at: id)
    }

}
