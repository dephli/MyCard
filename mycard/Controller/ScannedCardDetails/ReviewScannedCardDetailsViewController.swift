//
//  ReviewScannedCardDetailsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 5/1/21.
//

import UIKit

class ReviewScannedCardDetailsViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var labelledDetailsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var unlabelledDetailsStackViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var labelledDetailsStackView: LabelledScannedDetailsStackView!
    @IBOutlet weak var unlabelledDetailStackView: UnlabelledScannedDetailsStackView!

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Review scanned details"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
        labelledDetailsStackViewHeightConstraint.isActive = false
        unlabelledDetailsStackViewHeightConstraint.isActive = false
        labelledDetailsStackView.configure()
        unlabelledDetailStackView.configure()
        
    }

// MARK: - Actions

    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
