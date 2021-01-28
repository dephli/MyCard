//
//  Email.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/14/20.
//

import Foundation

enum EmailType: String, Codable {
    case Personal
    case Work
    case Other
}

struct Email: Codable {
    var type: EmailType
    var address: String
}
