//
//  AddDetailViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 5/28/21.
//

import UIKit

class AddDetailViewController: UIViewController {
// MARK: - Outlets
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var label: UILabel!
    var viewmodel: ReviewScannedCardDetailsViewModel!

// MARK: - variables
    var selectedLabel: (type: String, subType: String)!

// MARK: - Viewcontroller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()
    }

    override func viewWillAppear(_ animated: Bool) {
        label.text = selectedLabel.0
    }

// MARK: - Actions
    @IBAction func donePressed(_ sender: Any) {
        viewmodel.addDetail(detailTextField.text!, args: selectedLabel)
        let  vc =  self.navigationController?.viewControllers.filter({$0 is ReviewScannedCardDetailsViewController}
        ).first
        self.navigationController?.popToViewController(vc!, animated: true)
    }
}
