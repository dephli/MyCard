//
//  SetupCardViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/6/20.
//

import UIKit

class SetupCardViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var setupLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var arrowButton: UIButton!

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dismissKey()
        descriptionLabel.style(with: K.TextStyles.heading1)
        setupLabel.style(with: K.TextStyles.subTitle)
        self.hero.isEnabled = true
        arrowButton.hero.id = "arrowButton"
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

// MARK: - Actions
    @IBAction func arrowButtonPressed(_ sender: UIButton) {
        return
    }

    @IBAction func skipButtonPressed(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .fade
        transition.subtype = .none
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        view.window?.layer.add(transition, forKey: kCATransition)
    }
}
