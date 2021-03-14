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

    var viewModel: ContactsCellViewModel! {
        didSet {
            nameInitialsLabel.text = viewModel.nameInitials
            nameLabel.text = viewModel.fullName
            organizationLabel.text = viewModel.companyName
            descriptionLabel.text = viewModel.role
            avatarImageView.isHidden = viewModel.avatarImageIsHidden
            avatarImageView.image = nil
            avatarImageView.loadThumbnail(urlSting: viewModel.avatarImageUrl ?? "")
            avatarContainerView.backgroundColor = viewModel.color.withAlphaComponent(0.1)
            nameInitialsLabel.textColor = viewModel.color
        }
    }

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
