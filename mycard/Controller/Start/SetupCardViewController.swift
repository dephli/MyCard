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

    // MARK: - properties
    let addCardBottomSheet = AddCardBottomSheet()

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dismissKey()
        descriptionLabel.style(with: K.TextStyles.heading1)
        setupLabel.style(with: K.TextStyles.subTitle)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

// MARK: - Actions
    @IBAction func arrowButtonPressed(_ sender: UIButton) {
        addCardBottomSheet.modalPresentationStyle = .custom
        addCardBottomSheet.delegate = self
        addCardBottomSheet.transitioningDelegate = self

        self.present(addCardBottomSheet, animated: true, completion: nil)
    }

    @IBAction func skipButtonPressed(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .fade
        transition.subtype = .none
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        view.window?.layer.add(transition, forKey: kCATransition)
        performSegue(withIdentifier: K.Segues.setupCardToProfileSetup, sender: self)
    }
}

// MARK: - UITransitioningDelegate
extension SetupCardViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - BottomSheetDelegate
extension SetupCardViewController: AddCardBottomSheetDelegate {
    func scanPhysicalCardPressed() {
        addCardBottomSheet.dismiss(animated: true)
        CardManager.shared.currentContactType = .createFirstCard
        self.performSegue(withIdentifier: K.Segues.setupCardToCamera, sender: self
        )
    }

    func addManuallyPressed() {
        CardManager.shared.currentContactType = .createFirstCard
        addCardBottomSheet.dismiss(animated: true)
        self.performSegue(withIdentifier: K.Segues.setupCardToPersonalInfo, sender: self)
    }
}
