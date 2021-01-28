//
//  Contact.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/9/20.
//

import Foundation

struct Contact: Codable {
    var name: Name
    var profilePicUrl: String?
    var occupation: String
    var organization: String
    var phoneNumbers: [PhoneNumber]
    var emailAddresses: [Email]
    var socialMediaProfiles: [SocialMedia]
    var business: Business
}
