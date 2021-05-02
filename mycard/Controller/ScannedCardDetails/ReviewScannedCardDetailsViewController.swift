//
//  ReviewScannedCardDetailsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 5/1/21.
//

import UIKit

class ReviewScannedCardDetailsViewController: UIViewController {

    @IBOutlet weak var labelledDetailsStackViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var labelledDetailsStackView: LabelledScannedDetailsStackView!

//    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Review scanned details"
        navigationController?.navigationBar.shadowImage = UIImage()
        labelledDetailsStackViewHeightConstraint.isActive = false
        labelledDetailsStackView.configure()
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
