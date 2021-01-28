//
//  PhoneNumber.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/13/20.
//

import Foundation

enum PhoneNumberType: String, Codable {
    case Home
    case Mobile
    case Work
    case Other
}

struct PhoneNumber: Codable {
    var type: PhoneNumberType
    var number: String?
}
