//
//  ContactsCell.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/9/20.
//

import UIKit

class ContactsCell: UITableViewCell {

    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        nameLabel.style(with: K.TextStyles.bodyBlackSemiBold)
        organizationLabel.style(with: K.TextStyles.subTitle)
        descriptionLabel.style(with: K.TextStyles.subTitle)

        // Configure the view for the selected state
    }
    
}
