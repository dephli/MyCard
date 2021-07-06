//
//  SelectLabelViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 5/23/21.
//

import UIKit

class SelectLabelViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var mobileNumberButton: UIButton!
    @IBOutlet weak var homeNumberButton: UIButton!
    @IBOutlet weak var workNumberButton: UIButton!
    @IBOutlet weak var otherNumberButton: UIButton!
    @IBOutlet weak var personalEmailButton: UIButton!
    @IBOutlet weak var workEmailButton: UIButton!
    @IBOutlet weak var otherEmailButton: UIButton!

// MARK: - variables
    var selectedLabel: (String, String) = (type: "", subType: "")
    var viewmodel: ReviewScannedCardDetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

// MARK: - Actions

    @IBAction func fullNamePressed(_ sender: UIButton) {
        self.selectedLabel = (type: sender.currentTitle!, subType: "")
        performSegue(withIdentifier: K.Segues.selectLabelToAddDetail, sender: self)
    }

    @IBAction func phoneDropDownPressed(_ sender: Any) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1) {
                self.homeNumberButton.isHidden.toggle()
                self.workNumberButton.isHidden.toggle()
                self.otherNumberButton.isHidden.toggle()
                self.mobileNumberButton.isHidden.toggle()
            }
        }
    }

    @IBAction func phoneNumberPressed(_ sender: UIButton) {
        self.selectedLabel = (type: "Phone number", subType: sender.currentTitle!)
        performSegue(withIdentifier: K.Segues.selectLabelToAddDetail, sender: self)
    }

    @IBAction func mailDropDownPressed(_ sender: Any) {
    }

    @IBAction func emailAddressPressed(_ sender: UIButton) {
        self.selectedLabel = (type: "Email address", subType: sender.currentTitle!)

        performSegue(withIdentifier: K.Segues.selectLabelToAddDetail, sender: self)
    }

    @IBAction func businessInfoPressed(_ sender: UIButton) {
        self.selectedLabel = (type: sender.currentTitle!, subType: "")
        performSegue(withIdentifier: K.Segues.selectLabelToAddDetail, sender: self)
    }

    @IBAction func socialMediaPressed(_ sender: UIButton) {
        self.selectedLabel = (type: sender.currentTitle!, subType: "")
        performSegue(withIdentifier: K.Segues.selectLabelToAddDetail, sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddDetailViewController {
            destination.selectedLabel = self.selectedLabel
            destination.viewmodel = viewmodel
        }
    }

}
