//
//  EditDetailViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 5/29/21.
//

import UIKit

class EditDetailViewController: UIViewController {
    enum DetailEditType {
        case labelled
        case unlabelled
    }
    // MARK: - Outlets
    @IBOutlet var detailTextField: UITextField!
    @IBOutlet weak var customNavBar: UINavigationBar!

    // MARK: - Variables
    var viewmodel: ReviewScannedCardDetailsViewModel!
    var editType: DetailEditType!
    var selectedDetailToEdit: (String, Int)!
    var selectedIndexToEdit: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKey()
        customNavBar.shadowImage = UIImage()
    }

    override func viewWillAppear(_ animated: Bool) {
        if editType == .labelled {
            detailTextField.text = viewmodel.findDetail(name: selectedDetailToEdit.0, index: selectedDetailToEdit.1)
        } else if editType == .unlabelled {
            detailTextField.text = viewmodel.findDetail(index: selectedIndexToEdit!)
        }
    }

    // MARK: - Actions
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func doneButtonPressed(_ sender: UIButton) {
        switch editType {
        case .labelled:
            viewmodel.editLabelledDetail(detailTextField.text!, args: selectedDetailToEdit)
        case .unlabelled:
            viewmodel.editUnlabelledDetail(detailTextField.text!, index: selectedIndexToEdit!)
        default:
            return
        }
        dismiss(animated: true, completion: nil)
    }
}
