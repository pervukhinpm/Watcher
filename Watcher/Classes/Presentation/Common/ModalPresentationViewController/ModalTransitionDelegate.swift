//
//  ModalTransitionDelegate.swift
//  Watcher
//
//  Created by Петр Первухин on 04/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

class ModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var modalInteractiveTransition: ModalInteractiveTransition
    var dismissAnimator = DismissAnimator()
    
    
    init(modalInteractiveTransition: ModalInteractiveTransition) {
        self.modalInteractiveTransition = modalInteractiveTransition
        super.init()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimator
    }
    
    func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return modalInteractiveTransition.hasStarted ? modalInteractiveTransition : nil
    }
    
}
