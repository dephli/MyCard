//
//  PersonalCardCollectionViewCell.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/13/21.
//

import UIKit

class PersonalCardCollectionViewCell: UICollectionViewCell {

// MARK: - Outlets
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!

// MARK: - Variables
    var contact: Contact? {
        didSet {
            setContactDetails()
        }
    }

// MARK: - CollectionView methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

// MARK: - Methods
    private func setContactDetails() {
        companyName.text = contact?.businessInfo?.companyName
        role.text = contact?.businessInfo?.role

        if let url = contact?.profilePicUrl {
            avatarImageView.loadThumbnail(urlSting: url)
        } else {
            if AuthService.avatarUrl != nil {
                avatarImageView.loadThumbnail(urlSting: AuthService.avatarUrl!)
            } else {
                avatarImageView.image = K.Images.profilePlaceholder
            }
        }
    }

}
