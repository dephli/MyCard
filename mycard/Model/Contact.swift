//
//  Contact.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/9/20.
//

import Foundation
import FirebaseFirestoreSwift

struct Contact: Codable, Identifiable {
    @DocumentID var id: String?
    var name: Name
    var profilePicUrl: String?
    var phoneNumbers: [PhoneNumber]
    var emailAddresses: [Email]
    var socialMediaProfiles: [SocialMedia]
    var businessInfo: BusinessInfo
    var note: String?
}
