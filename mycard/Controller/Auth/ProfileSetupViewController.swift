//
//  ProfileSetupViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/15/21.
//

import UIKit

class ProfileSetupViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.style(with: K.TextStyles.heading1)

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
    @IBAction func uploadImageButtonPressed(_ sender: Any) {
        
    }
    
}
