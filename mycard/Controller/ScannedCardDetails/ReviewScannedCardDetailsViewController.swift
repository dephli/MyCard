//
//  ReviewScannedCardDetailsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 5/1/21.
//

import UIKit
import RxCocoa
import RxSwift

class ReviewScannedCardDetailsViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var labelledDetailsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var unlabelledDetailsStackViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var labelledDetailsStackView: LabelledScannedDetailsStackView!
    @IBOutlet weak var unlabelledDetailStackView: UnlabelledScannedDetailsStackView!
// MARK: - Variables

    var viewModel: ReviewScannedCardDetailsViewModel!
    var disposeBag = DisposeBag()
    var currentUnlabelledIndex: Int?

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        labelledDetailsStackView.delegate = self
        unlabelledDetailStackView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Review scanned details"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
        labelledDetailsStackViewHeightConstraint.isActive = false
        unlabelledDetailsStackViewHeightConstraint.isActive = false
        viewModel.labelledScannedDetails.subscribe { [unowned self] contact in
            labelledDetailsStackView.configure(contact)
        }.disposed(by: disposeBag)

        viewModel.unlabelledScannedDetails.subscribe { [unowned self] details in
            unlabelledDetailStackView.configure(details: details)
        }.disposed(by: disposeBag)

    }

// MARK: - Actions

    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func createCardPressed(_ sender: Any) {

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AssignLabelToScannedDetailsViewController {
            destination.viewModel = viewModel
        }
    }
}

extension ReviewScannedCardDetailsViewController: LabelledScannedDetailsDelegate {
    func untag(detail: (String, Int)) {
        viewModel.untagLabelledDetail(name: detail.0, index: detail.1)
    }

    func edit(detail: (String, Int)) {
        viewModel.editLabelledDetail(name: detail.0, index: detail.1)
    }

    func swap(detail: (String, Int)) {
        viewModel.swapLabelledDetail(name: detail.0, index: detail.1)
    }

}

extension ReviewScannedCardDetailsViewController: UnlabelledScannedDetailsDelegate {
    func addLabel(id: Int) {
        viewModel.currentUnlabelledDetailIndex = id
        performSegue(withIdentifier: K.Segues.reviewScannedDetailsToAssignLabel, sender: self)
    }

    func duplicate(id: Int) {
        viewModel.duplicateDetail(at: id)

    }

    func remove(id: Int) {
        viewModel.deleteUnlabelledDetail(at: id)
    }

}
