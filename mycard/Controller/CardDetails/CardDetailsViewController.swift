//
//  CardDetailsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/29/20.
//

import UIKit

class CardDetailsViewController: UIViewController {
    
    @IBOutlet weak var nameInitialsLabel: UILabel!
    @IBOutlet weak var nameInitialsView: UIView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var workInfoLabel: UILabel!
    @IBOutlet weak var workLocationLabel: UILabel!
    @IBOutlet weak var socialMediaLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    @IBOutlet weak var cardViewFaceIndicator1: UIView!
    @IBOutlet weak var cardViewFaceIndicator2: UIView!
    
    @IBOutlet weak var socialMediaStackView: SocialMediaListStackView!
    @IBOutlet weak var socialMediaStackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var phoneTextLabel: UILabel!
    @IBOutlet weak var emailTextLabel: UILabel!
    @IBOutlet weak var workInfoTextLabel: UILabel!
    @IBOutlet weak var workLocationTextLabel: UILabel!
    
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var contactSummaryView: UIView!
    let imageView = UIImageView(image: UIImage(named: "nasa"))
    
    var isOpen = false
    
    fileprivate func setupUI() {
        socialMediaStackViewHeightConstraint.isActive = false
        socialMediaStackView.configure()
        customNavigationBar.shadowImage = UIImage()
        let randomColor = UIColor.random
        nameInitialsView.backgroundColor = randomColor
        nameInitialsView.alpha = 0.1
        nameInitialsLabel.textColor = randomColor
        nameLabel.style(with: K.TextStyles.bodyBlackSemiBold)
        jobTitleLabel.style(with: K.TextStyles.subTitle)
        noteTextField.bottomBorder(color: UIColor(named: K.Colors.mcBlue)!, width: 1)
        noteTextField.attributedPlaceholder = NSAttributedString(string: noteTextField.placeholder!, attributes: [
                                                                    NSAttributedString.Key.foregroundColor: UIColor(cgColor: UIColor(named: K.Colors.mcBlue)!.cgColor)])
        
        phoneLabel.style(with: K.TextStyles.subTitle)
        nameLabel.style(with: K.TextStyles.subTitle)
        noteLabel.style(with: K.TextStyles.subTitle)
        workInfoLabel.style(with: K.TextStyles.subTitle)
        workLocationLabel.style(with: K.TextStyles.subTitle)
        emailAddressLabel.style(with: K.TextStyles.subTitle)
        socialMediaLabel.style(with: K.TextStyles.subTitle)

        
        nameTextLabel.style(with: K.TextStyles.bodyBlack)
        phoneTextLabel.style(with: K.TextStyles.bodyBlack)
        emailTextLabel.style(with: K.TextStyles.bodyBlack)
        workInfoTextLabel.style(with: K.TextStyles.bodyBlack)
        workLocationTextLabel.style(with: K.TextStyles.bodyBlack)
    }
    
    var contact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleCardDrag))
        
        gesture.direction = .down
        cardView.addGestureRecognizer(gesture)
        
    }
    
    @IBAction func onBackButtonPressed(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .reveal
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)

        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCardDrag() {
        DispatchQueue.main.async { [self] in
            if isOpen {
                isOpen.toggle()
                cardView.addSubview(contactSummaryView)
                UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromBottom, animations: nil, completion: nil)
                cardViewFaceIndicator1.backgroundColor = UIColor(named: K.Colors.mcBlack)
                cardViewFaceIndicator2.backgroundColor = UIColor(named: K.Colors.mcBlack10)
                
            } else {
                
                isOpen.toggle()
                
                cardViewFaceIndicator2.backgroundColor = UIColor(named: K.Colors.mcBlack)
                cardViewFaceIndicator1.backgroundColor = UIColor(named: K.Colors.mcBlack10)

                
                imageView.layer.cornerRadius = 8
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                cardView.addSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 0).isActive = true
                imageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 0).isActive = true
                imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 0).isActive = true
                imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 0).isActive = true
                
                UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromBottom, animations: nil, completion: nil)

            }
        }
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
