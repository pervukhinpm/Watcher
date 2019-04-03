//
//  CustomModalPresentationController.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class DimmingModalPresentationController: UIPresentationController {
    
    // MARK: - Properties
    
    private var dimmingView: UIView!

    
    // MARK: - Initializers
    
    override init(presentedViewController: UIViewController, 
                  presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, 
                   presenting: presentingViewController)
        setupDimmingView()
    }
    
    
    // MARK: - Setup
    
    @objc internal func userTappedInDimmingArea(_ gestureRecognizer: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    private func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        dimmingView.alpha = 0.0
        dimmingView.addGestureRecognizer(
            UITapGestureRecognizer(target: self,
                                   action: #selector(userTappedInDimmingArea(_:))))
    }
    
    
    // MARK: - UIPresentationController Methods
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height - parentSize.height / 20)
    }
    
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController, 
                          withParentContainerSize: containerView!.bounds.size)
        frame.origin.y = containerView!.frame.height / 20
        return frame
    }
    
    
    override func presentationTransitionWillBegin() {
        
        containerView?.insertSubview(dimmingView, at: 0)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                           options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
        
    }
    
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
}
