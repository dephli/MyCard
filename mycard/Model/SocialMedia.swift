//
//  SocialMedia.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/15/20.
//

import Foundation
import UIKit

enum SocialMediaType: String, Codable {
    case Facebook
    case Twitter
    case LinkedIn
    case Instagram
}

struct SocialMedia: Codable, Equatable, Hashable {
    var usernameOrUrl: String
    var type: SocialMediaType
}
