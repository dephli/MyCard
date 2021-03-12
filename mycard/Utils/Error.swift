//
//  Error.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/11/21.
//

import Foundation

class CustomError: NSObject, LocalizedError {
    var desc = ""

    init(str: String) {
        desc = str
    }

    override var description: String {
        return desc
    }

    var errorDescription: String? {
        return self.description
    }

}
