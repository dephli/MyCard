//
//  UIVIewProgressView.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/5/21.
//

import Foundation

import UIKit

// activity view
fileprivate var aView: UIView?

extension UIViewController {
    func showActivityIndicator() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = K.Colors.Black10
        aView?.alpha = 0.5
        
        
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeActivityIndicator() {
        aView?.removeFromSuperview()
        aView = nil
    }
}
