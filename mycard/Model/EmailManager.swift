//
//  EmailManager.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/14/20.
//

import Foundation
import RxCocoa
import RxSwift

struct EmailManager {
    private init () {}
    static var manager = EmailManager()

    var list: BehaviorRelay<[Email]> = BehaviorRelay(value: [Email(type: .Personal, address: "")])

    func append(with email: Email) {
        var emailList = list.value
        emailList.append(email)
        list.accept(emailList)
    }

    func replace(with emails: [Email]) {
        if emails.isEmpty {
            list.accept([Email(type: .Personal, address: "")])
        } else {
            list.accept(emails)
        }
    }

    func remove(at index: Int) {
        var emailList = list.value
        emailList.remove(at: index)
        list.accept(emailList)
    }
    
    var emails: [Email] {
        list.value
    }
}
