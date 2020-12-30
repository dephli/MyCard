//
//  PersonalInfoViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/9/20.
//

import UIKit
import RxSwift

class PersonalInfoViewController: UIViewController {
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var socialMediaLabel: UILabel!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var prefixTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var suffixTextField: UITextField!
    
    @IBOutlet weak var socialMediaButton: UIButton!
    
    @IBOutlet weak var phoneNumbersStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailListStackviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var socialMediaListStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileButtonToStackViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileButtonToLabelConstraint: NSLayoutConstraint!
    

    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var phoneNumbersStackView: PhoneListStackView!
    @IBOutlet weak var emailListStackView: EmailListStackView!
    @IBOutlet weak var socialMediaListStackView: SocialMediaListStackView!
    
    
    @IBOutlet weak var customNavBar: CustomNavigationBar!
    
    let phoneNumberObservable = PhoneNumberManager.numbers.list.asObservable()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissKey()
        
        uiSetup()

        nameSetup()
 
        phoneNumbersStackViewHeightConstraint.isActive = false
        emailListStackviewHeightConstraint.isActive = false
        socialMediaListStackViewHeightConstraint.isActive = false
//        profileButtonToStackViewConstraint.isActive = false
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewPhonePressed(_ sender: Any) {
        PhoneNumberManager.numbers.append(with: PhoneNumber(type: "Home", number: ""))
    }
    @IBAction func addEmailPressed(_ sender: Any) {
        EmailManager.manager.append(with: Email(type: "Personal", address: ""))
    }
    @IBAction func socialMediaButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: K.Segues.personalInfoToSocialMedia, sender: self)
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: K.Segues.personalInfoToWorkInfo, sender: self)
    }
    
}


//MARK: - UI Setup
extension PersonalInfoViewController {
    
    func uiSetup() {
        socialMediaButton.setTitle(with: K.TextStyles.bodyBlue, for: .normal)
        socialMediaListStackView.configure()
        customNavBar.setup(backIndicatorImage: "xmark")
        personalInfoLabel.style(with: K.TextStyles.heading1)
        pageCountLabel.style(with: K.TextStyles.subTitle)
        emailLabel.style(with: K.TextStyles.subTitle)
        socialMediaLabel.style(with: K.TextStyles.subTitle)
        
        nameTitleLabel.style(with: K.TextStyles.captionBlack60)
        phoneTitleLabel.style(with: K.TextStyles.captionBlack60)
        
        phoneNumberObservable.subscribe(onNext: { [unowned self] numbers in
            phoneNumbersStackView.configure(with: numbers)
        }).disposed(by: disposeBag)

        EmailManager.manager.list.asObservable().subscribe { [unowned self] emails in
            emailListStackView.configure(with: emails)
        }.disposed(by: disposeBag)
        
    }
}


//MARK: - Name Setup
extension PersonalInfoViewController {
    func nameSetup() {
        
        let stackViewLength = nameStackView.arrangedSubviews.count
        nameStackView.arrangedSubviews[0].alpha = 1

        for i in 1 ... stackViewLength-1 {
            nameStackView.arrangedSubviews[i].isHidden = true
            nameStackView.arrangedSubviews[i].alpha = 0
        }
    }
    
    @IBAction func bottomCaretButtonPressed(_ sender: UIButton) {

        let stackViewLength = nameStackView.arrangedSubviews.count
        

        DispatchQueue.main.async {
                self.nameStackView.arrangedSubviews[0].alpha = 0

            UIView.animate(withDuration: 0.3) {
                for i in 0 ..< stackViewLength{
                    let view = self.nameStackView.arrangedSubviews[i]
                    view.isHidden.toggle()
                    
                
                    if i != 0 {
                        if view.alpha == 0 {
                            view.alpha = 1
                        } else {
                            view.alpha = 0
                        }
                    }
                
                }
            } completion: { completed in
                self.nameStackView.arrangedSubviews[0].alpha = 1
            }

        }
    }
}
