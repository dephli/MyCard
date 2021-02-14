//
//  PersonalCardCollectionViewCell.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/13/21.
//

import UIKit

class PersonalCardCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: PersonalCardCollectionViewCell.self)

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
