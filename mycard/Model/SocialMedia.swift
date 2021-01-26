//
//  SocialMedia.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/15/20.
//

import Foundation
import UIKit

enum SocialMediaType:String, Codable {
    case facebook
    case twitter
    case linkedin
    case instagram
}

struct SocialMedia: Codable, Equatable, Hashable {
    let link: String
    let type: SocialMediaType
}
