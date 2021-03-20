//
//  PhoneNumberList.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/13/20.
//

import Foundation
import RxCocoa
import RxSwift

struct PhoneNumberManager {
    private init () {}
    static let manager = PhoneNumberManager()

    var list: BehaviorRelay<[PhoneNumber]> = BehaviorRelay(value: [PhoneNumber(type: .Mobile, number: "")])

    func append(with number: PhoneNumber) {
        let phoneList = list.value
        let newValue = phoneList + [number]
        list.accept(newValue)
    }

    func remove(at index: Int) {
        var phoneList = list.value
        phoneList.remove(at: index)
        list.accept(phoneList)
    }

    func replace(with numbers: [PhoneNumber]) {
        if numbers.isEmpty {
            list.accept([
                PhoneNumber(type: .Mobile, number: "")
            ])
        } else {
            list.accept(numbers)
        }
    }

    var numbers: [PhoneNumber] {
        list.value
    }

}
