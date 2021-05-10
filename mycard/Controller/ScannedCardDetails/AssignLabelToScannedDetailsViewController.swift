//
//  AssignLabelToScannedDetailsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 5/5/21.
//

import UIKit

class AssignLabelToScannedDetailsViewController: UIViewController {

    var viewModel: ReviewScannedCardDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func fullNamePressed(_ sender: UIButton) {
//        let contact = viewModel.labelledScannedDetails.value
        viewModel.setFullName()
        dismiss(animated: true)

    }

    @IBAction func phoneNumberPressed(_ sender: UIButton) {
        viewModel.setPhoneNumber(type: sender.currentTitle!)
        dismiss(animated: true)
    }

    @IBAction func emailPressed(_ sender: UIButton) {
        viewModel.setEmail(type: sender.currentTitle!)
        dismiss(animated: true)
    }

    @IBAction func businessInfoPressed(_ sender: UIButton) {
        viewModel.setBusinessInfo(type: sender.currentTitle!)
        dismiss(animated: true)
    }

    @IBAction func socialMediaPressed(_ sender: Any) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
