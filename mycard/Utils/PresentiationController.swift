//
//  BottomSheetPresentiationController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 4/1/21.
//

import Foundation
import UIKit

class PresentationController: UIPresentationController {

  let blurEffectView: UIVisualEffectView!
  var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()

  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
      let blurEffect = UIBlurEffect(style: .dark)
      blurEffectView = UIVisualEffectView(effect: blurEffect)
      super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
      tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.blurEffectView.isUserInteractionEnabled = true
      self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
  }

  override var frameOfPresentedViewInContainerView: CGRect {
      CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.8),
             size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
              0.2))
  }

  override func presentationTransitionWillBegin() {
      self.blurEffectView.alpha = 0
      self.containerView?.addSubview(blurEffectView)
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
          self.blurEffectView.alpha = 0.3
      }, completion: { (_) in })
  }

  override func dismissalTransitionWillBegin() {
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
          self.blurEffectView.alpha = 0
      }, completion: { (_) in
          self.blurEffectView.removeFromSuperview()
      })
  }

  override func containerViewWillLayoutSubviews() {
      super.containerViewWillLayoutSubviews()
    presentedView!.roundedCorners(corners: [.topLeft, .topRight], radius: 22)
  }

  override func containerViewDidLayoutSubviews() {
      super.containerViewDidLayoutSubviews()
      presentedView?.frame = frameOfPresentedViewInContainerView
      blurEffectView.frame = containerView!.bounds
  }

  @objc func dismissController() {
      self.presentedViewController.dismiss(animated: true, completion: nil)
  }
}
