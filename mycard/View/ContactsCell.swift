//
//  ContactsCell.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/9/20.
//

import UIKit

class ContactsCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameInitialsLabel: UITextField!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var nameInitialsContainerView: UIView!
    
    var name: String? {
        didSet {
            let randomColor = UIColor.random
            nameInitialsLabel.textColor = randomColor
            nameInitialsContainerView.backgroundColor = randomColor
            nameInitialsContainerView.alpha = 0.2
            nameInitialsLabel.text = String((name?.prefix(2))!)
        }
    }
    
    var avatarImageView: UIImageView? {
        didSet {
            guard let avatarImageView = avatarImageView else {
                return
            }
            avatarImageView.layer.cornerRadius = 20
            avatarImageView.contentMode = .scaleAspectFill
            avatarImageView.clipsToBounds = true
            
            imageViewContainer.addSubview(avatarImageView)
            avatarImageView.translatesAutoresizingMaskIntoConstraints = false
            avatarImageView.topAnchor.constraint(equalTo: self.imageViewContainer.topAnchor, constant: 0).isActive = true
            avatarImageView.bottomAnchor.constraint(equalTo: self.imageViewContainer.bottomAnchor, constant: 0).isActive = true
            avatarImageView.leadingAnchor.constraint(equalTo: self.imageViewContainer.leadingAnchor, constant: 0).isActive = true
            avatarImageView.trailingAnchor.constraint(equalTo: self.imageViewContainer.trailingAnchor, constant: 0).isActive = true
        }
    }

    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        nameLabel.style(with: K.TextStyles.bodyBlackSemiBold)
        organizationLabel.style(with: K.TextStyles.subTitle)
        descriptionLabel.style(with: K.TextStyles.subTitle)

        // Configure the view for the selected state
    }
    
}
