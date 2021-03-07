//
//  ContactsCell.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/9/20.
//

import UIKit

class ContactsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameInitialsLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarContainerView: UIView!

    var contact: Contact? {
        didSet {
            nameLabel.text = contact?.name.fullName
            organizationLabel.text = contact?.businessInfo?.companyName
            descriptionLabel.text = contact?.businessInfo?.role

            self.avatarImageView.image = nil
            if let url = contact?.profilePicUrl {
                setAvatarImageView(url: url)
            } else {
                avatarImageView.isHidden = true
            }

            if contact?.name != nil {
                let firstName = contact?.name.firstName
                let lastName = contact?.name.lastName
                if firstName?.isEmpty == false && lastName?.isEmpty == false {
                    nameInitialsLabel.text = "\(contact!.name.firstName!.prefix(1))\(contact!.name.lastName!.prefix(1))"
                } else if firstName?.isEmpty == false && lastName?.isEmpty == true {
                    nameInitialsLabel.text = "\(contact!.name.firstName!.prefix(2))"
                } else if firstName?.isEmpty == true && lastName?.isEmpty == false {
                    nameInitialsLabel.text = "\(contact!.name.lastName!.prefix(2))"
                }

            }

            let randomColor = UIColor.random
            let randomFaded = randomColor.withAlphaComponent(0.1)

            avatarContainerView.backgroundColor = randomFaded
            nameInitialsLabel.textColor = randomColor

        }
    }

    func setAvatarImageView(url: String) {
        avatarImageView.loadThumbnail(urlSting: url)
        avatarImageView.isHidden = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = contact?.name.fullName
        organizationLabel.text = contact?.businessInfo?.companyName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        nameLabel.style(with: K.TextStyles.bodyBlackSemiBold)
        organizationLabel.style(with: K.TextStyles.subTitle)
        descriptionLabel.style(with: K.TextStyles.subTitle)

        // Configure the view for the selected state
    }

}
