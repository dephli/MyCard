//
//  ChangePhoneNumberViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/18/21.
//

import UIKit

class ChangePhoneNumberViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.style(with: K.TextStyles.heading1)
        titleLabel.textAlignment = .center
        subtitleLabel.style(with: K.TextStyles.subTitle)
        navBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
