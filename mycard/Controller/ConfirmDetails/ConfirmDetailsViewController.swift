//
//  ConfirmDetailsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/21/20.
//

import UIKit

class ConfirmDetailsViewController: UIViewController {

    @IBOutlet weak var nameInitialsLabel: UILabel!
    @IBOutlet weak var nameInitialsView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavigationBar.shadowImage = UIImage()
        let randomColor = UIColor.random
        nameInitialsView.backgroundColor = randomColor
        nameInitialsView.alpha = 0.1

        nameInitialsLabel.textColor = randomColor
        nameLabel.style(with: K.TextStyles.bodyBlackSemiBold)
        jobTitleLabel.style(with: K.TextStyles.subTitle)
    }

}
