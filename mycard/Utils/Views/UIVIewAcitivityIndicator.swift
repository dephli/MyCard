//
//  UIVIewProgressView.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/5/21.
//

import Foundation

import UIKit

// activity view
private var aView: UIView?

extension UIViewController {
    func showActivityIndicator() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = K.Colors.Black10
        let innerView = UIView()
        aView?.addSubview(innerView)
        innerView.translatesAutoresizingMaskIntoConstraints = false
        innerView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        innerView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        innerView.centerYAnchor.constraint(equalTo: aView!.centerYAnchor).isActive = true
        innerView.centerXAnchor.constraint(equalTo: aView!.centerXAnchor).isActive = true
        innerView.backgroundColor = K.Colors.Black60
        innerView.layer.cornerRadius = 8
        var ai = UIActivityIndicatorView(style: .white)
        if #available(iOS 13.0, *) {
            ai = UIActivityIndicatorView(style: .large)
        }
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.startAnimating()
        ai.color = .white
        innerView.addSubview(ai)
        ai.centerYAnchor.constraint(equalTo: innerView.centerYAnchor).isActive = true
        ai.centerXAnchor.constraint(equalTo: innerView.centerXAnchor).isActive = true
        self.view.addSubview(aView!)
    }

    func removeActivityIndicator() {
        aView?.removeFromSuperview()
        aView = nil
    }
}
