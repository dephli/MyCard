//
//  ContactManager.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 1/12/21.
//

import Foundation
import RxCocoa

class ContactCreationManager {
    private init (){}
    
    let contact: BehaviorRelay<Contact> =
        BehaviorRelay(value:
                        Contact(name:
                                    Name( prefix: nil, fullName: nil, firstName: nil, middleName: nil, lastName: nil, suffix: nil),
                                profilePicUrl: nil,
                                phoneNumbers: [],
                                emailAddresses: [],
                                socialMediaProfiles: [],
                                businessInfo:
                                    BusinessInfo(role: "", companyName: "", companyAddress: "", companyLogo: nil), note: nil))
    
    static let manager = ContactCreationManager()
    
}
