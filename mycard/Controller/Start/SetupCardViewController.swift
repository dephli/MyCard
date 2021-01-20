//
//  SetupCardViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/6/20.
//

import UIKit

class SetupCardViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var setupLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var arrowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.style(with: K.TextStyles.heading1)
        setupLabel.style(with: K.TextStyles.subTitle)
        self.hero.isEnabled = true
        arrowButton.hero.id = "arrowButton"
        
    }
    
    @objc
    func userLoggedIn() {
//        
    }
    
    @IBAction
    func arrowButtonPressed(_ sender: UIButton) {
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name("UserLoggedIn"), object: nil)

//        NotificationCenter.default.post(name: Notification.Name("loginNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func skipButtonPressed(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .fade
        transition.subtype = .none
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeIn)
        view.window?.layer.add(transition, forKey: kCATransition)
    }
    
}
