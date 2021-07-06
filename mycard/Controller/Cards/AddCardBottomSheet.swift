//
//  AddCardBottomSheetViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 4/17/21.
//

import Foundation
import UIKit

protocol AddCardBottomSheetDelegate: AnyObject {
    func scanPhysicalCardPressed()
    func addManuallyPressed()
}

class AddCardBottomSheet: BottomSheetViewController {
    weak var delegate: AddCardBottomSheetDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func scanCardPressed(_ sender: Any) {
        delegate.scanPhysicalCardPressed()
    }

    @IBAction func addManuallyPressed(_ sender: Any) {
        delegate.addManuallyPressed()
    }
}
