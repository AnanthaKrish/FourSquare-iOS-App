//
//  OptionsPresentationController.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 02/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import UIKit

// presenter controller to handle the HalfView for the OptionsViewController
class OptionsPresentationController: UIPresentationController {
    
    let blurEffectView: UIVisualEffectView!
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    // Dismiss action for the gesture
    @objc func dismiss(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    /**
     Initialize the presentercontroller
     - parameter presentedViewController: presented uiviewcontroller
     - parameter presentingViewController: presenting uiviewcontroller
     */
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
       
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Setup modal controller frame
    override var frameOfPresentedViewInContainerView: CGRect{
       
        return CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.4), size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height * 0.6))
    }
    
    override func dismissalTransitionWillBegin() {
       
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func presentationTransitionWillBegin() {
       
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.blurEffectView.alpha = 0.5
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        
        super.containerViewWillLayoutSubviews()
        presentedView!.layer.masksToBounds = true
        presentedView!.layer.cornerRadius = 10
        presentedView!.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

    }
    
    override func containerViewDidLayoutSubviews() {
       
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView!.bounds
    }
}
