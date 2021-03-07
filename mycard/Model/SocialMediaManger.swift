//
//  SocialMediaManger.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/15/20.
//

import Foundation
import RxCocoa

struct SocialMediaManger {
    private init () {}
    static let manager = SocialMediaManger()

    var list: BehaviorRelay<[SocialMedia]> = BehaviorRelay(value: [])

    func add(with account: SocialMedia) {
        var socialMediaList = list.value
        socialMediaList.append(account)
        list.accept(socialMediaList)
    }

    func replace(with accounts: [SocialMedia]) {
        list.accept(accounts)
        print(list.value)
    }

    func remove(at index: Int) {
        var socialMediaList = list.value
        socialMediaList.remove(at: index)
        list.accept(socialMediaList)
    }

     var getAll: [SocialMedia] {
        return list.value
    }
}
