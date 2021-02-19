//
//  SettingsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/18/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var navBarTitle: UIBarButtonItem!
    @IBOutlet weak var numberTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.style(with: K.TextStyles.captionBlack60)
        numberLabel.style(with: K.TextStyles.captionBlack60)
        nameTextLabel.style(with: K.TextStyles.bodyBlack)
        numberTextLabel.style(with: K.TextStyles.bodyBlack)
        navigationBar.shadowImage = UIImage()
        let font = UIFont(name: "inter", size: 18)
        navBarTitle.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
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
