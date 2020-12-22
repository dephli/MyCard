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
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var contactSummaryView: UIView!
    let imageView = UIImageView(image: UIImage(named: "nasa"))
    
    var isOpen = false
    
    fileprivate func setupUI() {
        customNavigationBar.shadowImage = UIImage()
        let randomColor = UIColor.random
        nameInitialsView.backgroundColor = randomColor
        nameInitialsView.alpha = 0.1
        
        nameInitialsLabel.textColor = randomColor
        nameLabel.style(with: K.TextStyles.bodyBlackSemiBold)
        jobTitleLabel.style(with: K.TextStyles.subTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleCardDrag))
        
        gesture.direction = .down
        cardView.addGestureRecognizer(gesture)
        
        
    }
    
    @objc func handleCardDrag() {
        if isOpen {
            isOpen.toggle()
            cardView.addSubview(contactSummaryView)
            UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromBottom, animations: nil, completion: nil)
            
        } else {
            isOpen.toggle()
            
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
