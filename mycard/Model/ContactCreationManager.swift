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
    
    let contact: BehaviorRelay<Contact> = BehaviorRelay(value: Contact(prefix: nil, fullName: nil, firsName: nil, middleName: nil, lastName: nil, suffix: nil, image: nil, occupation: "", organization: "", phoneNumber: [], emailAddress: [], socialMedia: [], companyName: "", role: "", companyLocation: ""))
    
    static let manager = ContactCreationManager()
    
}
