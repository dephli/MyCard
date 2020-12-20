//
//  SocialMedia.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/15/20.
//

import Foundation
import UIKit

struct SocialMedia {
    
    enum Site {
        case linkedin
        case facebook
        case twitter
        case instagram
    }
    var link: String
    let type: Site
    let icon: UIImage
}
