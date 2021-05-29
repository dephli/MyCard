//
//  EditDetailViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 5/29/21.
//

import UIKit

class EditDetailViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet var detailTextField: UITextField?

    // MARK: - Variables
    var viewmodel: ReviewScannedCardDetailsViewModel!
    var selectedDetailToEdit: (name: String, index: Int)!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doneButtonPressed(_ sender: UIButton) {
    }
    
}
