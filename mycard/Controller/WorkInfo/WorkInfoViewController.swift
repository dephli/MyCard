//
//  WorkInfoViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/20/20.
//

import UIKit

class WorkInfoViewController: UIViewController {

    @IBOutlet weak var navigationBar: CustomNavigationBar!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var workInfoSectionLabel: UILabel!
    @IBOutlet weak var workLocationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    

    @IBAction func backBarButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: K.Segues.workInfoToConfirmDetails, sender: self)
    }
}

extension WorkInfoViewController {
    func setupUI() {
        navigationBar.shadowImage = UIImage()
        titleLabel.style(with: K.TextStyles.heading1)
        pageCountLabel.style(with: K.TextStyles.subTitle)
        workInfoSectionLabel.style(with: K.TextStyles.subTitle)
        workLocationLabel.style(with: K.TextStyles.subTitle)
        infoLabel.style(with: K.TextStyles.subTitleBlue)
        
    }
}
