//
//  Contact.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/9/20.
//

import Foundation

struct Contact: Codable {
    var prefix: String?
    var fullName: String?
    var firsName: String?
    var middleName: String?
    var lastName: String?
    var suffix: String?
    var image: String?
    var occupation: String
    var organization: String
    var phoneNumber: [PhoneNumber]
    var emailAddress: [Email]
    var socialMedia: [SocialMedia]
    var companyName: String
    var role: String
    var companyLocation: String
}
