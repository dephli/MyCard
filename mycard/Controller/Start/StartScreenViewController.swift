//
//  ViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/5/20.
//

import UIKit
import Hero

class StartScreenViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!

// MARK: - ViewController methods
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.hero.id = "arrowButton"
        infoLabel.style(with: K.TextStyles.heading1)

        NotificationCenter.default.post(name: Notification.Name("UserLoggedIn"), object: nil)
    }
}
