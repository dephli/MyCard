//
//  SocialMediaManger.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/15/20.
//

import Foundation
import RxCocoa

struct SocialMediaManger {
    static let manager = SocialMediaManger()
    
    var list: BehaviorRelay<[SocialMedia]> = BehaviorRelay(value: [])
}
